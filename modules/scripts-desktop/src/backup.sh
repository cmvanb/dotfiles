#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Additive multi-host backup to a shared NTFS drive.
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

debug::assert_dependency rsync
debug::assert_dependency pv

# Defaults
#-------------------------------------------------------------------------------

MOUNT_POINT="/run/media/${USER}/Backup"
DEST_SUBDIR=""
SOURCE="${HOME}/"
LOG_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/backup"
CONFLICT_LOG_ON_DEST=".backup-conflicts.log"

HOSTNAME_SHORT="${HOSTNAME%%.*}"

DEFAULT_INCLUDE=(
    "Documents"
    "Projects"
    "Wiki"
)

DEFAULT_EXCLUDE=(
    ".stfolder"
    ".stignore"
    ".stignore_synced"
    ".cache"
    "node_modules"
    "*/target"
    "*/.git/objects"
    "*.tmp"
    "*.swp"
    "__pycache__"
    "*.pyc"
)

INCLUDE=()
EXCLUDE=()
DRY_RUN=false
USE_CHECKSUM=false
NO_CONFLICT_PROMPT=false

# Colours & UI
#-------------------------------------------------------------------------------

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'
BLUE=$'\033[0;34m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
RESET=$'\033[0m'

info()    { echo -e "${CYAN}${BOLD}[INFO]${RESET}    $*"; }
success() { echo -e "${GREEN}${BOLD}[OK]${RESET}      $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${RESET}    $*"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${RESET}   $*" >&2; }
section() { echo -e "\n${BOLD}${BLUE}── $*${RESET}"; }
hr()      { printf "${DIM}%60s${RESET}\n" '' | tr ' ' '-'; }

# Argument parsing
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF

${BOLD}Usage:${RESET} $(basename "$0") [options]

${BOLD}Options:${RESET}
  --dry-run                Preview, no files written
  --mount-point PATH       External drive mount point
                           Default: /run/media/\$USER/Backup
  --include DIR [DIR ...]  Dirs to back up, relative to \$HOME
  --exclude PATTERN [...]  Patterns to exclude within included dirs
  --checksum               Conflict detection via content hash (slower)
  --no-conflict-prompt     Non-interactive: keep dest for all conflicts
  -h, --help               Show this help

${BOLD}Conflict resolution keys:${RESET}
  [s] keep Source   overwrite destination with your local file
  [d] keep Dest     leave destination file as-is
  [S/D]             apply choice to all remaining conflicts

${BOLD}Conflict definition:${RESET}
  Any file present on both sides with a differing size or modification
  time is flagged as a conflict, regardless of which side is newer.
  Files only present on the destination are never touched.

EOF
}

CLI_INCLUDE=()
CLI_EXCLUDE=()
CLI_MOUNT_POINT=""
PARSING_INCLUDE=false
PARSING_EXCLUDE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)            DRY_RUN=true;            PARSING_INCLUDE=false; PARSING_EXCLUDE=false; shift ;;
        --checksum)           USE_CHECKSUM=true;        PARSING_INCLUDE=false; PARSING_EXCLUDE=false; shift ;;
        --no-conflict-prompt) NO_CONFLICT_PROMPT=true;  PARSING_INCLUDE=false; PARSING_EXCLUDE=false; shift ;;
        --mount-point)        CLI_MOUNT_POINT="$2";     PARSING_INCLUDE=false; PARSING_EXCLUDE=false; shift 2 ;;
        --include)            PARSING_INCLUDE=true; PARSING_EXCLUDE=false; shift ;;
        --exclude)            PARSING_EXCLUDE=true; PARSING_INCLUDE=false; shift ;;
        -h|--help)            usage; exit 0 ;;
        --*)                  error "Unknown option: $1"; usage; exit 1 ;;
        *)
            if   $PARSING_INCLUDE; then CLI_INCLUDE+=("$1")
            elif $PARSING_EXCLUDE; then CLI_EXCLUDE+=("$1")
            else error "Unexpected argument: $1"; usage; exit 1
            fi
            shift ;;
    esac
done

# Apply precedence: CLI > defaults
#-------------------------------------------------------------------------------

[[ ${#INCLUDE[@]} -eq 0 ]] && INCLUDE=("${DEFAULT_INCLUDE[@]}")
[[ ${#EXCLUDE[@]} -eq 0 ]] && EXCLUDE=("${DEFAULT_EXCLUDE[@]}")
[[ ${#CLI_INCLUDE[@]} -gt 0 ]] && INCLUDE=("${CLI_INCLUDE[@]}")
[[ ${#CLI_EXCLUDE[@]} -gt 0 ]] && EXCLUDE=("${CLI_EXCLUDE[@]}")
[[ -n "${CLI_MOUNT_POINT}" ]]  && MOUNT_POINT="${CLI_MOUNT_POINT}"

DEST="${MOUNT_POINT}/${DEST_SUBDIR}/"

# Pre-flight
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}╔════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║         Home Directory Backup          ║${RESET}"
echo -e "${BOLD}║  host: $(printf '%-32s' "${HOSTNAME_SHORT}")║${RESET}"
echo -e "${BOLD}╚════════════════════════════════════════╝${RESET}"
echo ""

$DRY_RUN && warn "DRY RUN — no files will be written" && echo ""

[[ -d "${MOUNT_POINT}" ]] || {
    error "Mount point '${MOUNT_POINT}' not found."
    error "Drive not mounted? Override with --mount-point PATH"
    exit 1
}

if ! mountpoint -q "${MOUNT_POINT}" 2>/dev/null; then
    warn "Not a recognised mount point: ${MOUNT_POINT}"
    read -rp "Continue anyway? [y/N] " _c
    [[ "${_c,,}" == "y" ]] || { info "Aborted."; exit 0; }
fi

mkdir -p "${DEST}" || { error "Cannot create ${DEST} — drive read-only?"; exit 1; }
[[ -w "${DEST}" ]]  || { error "Destination not writable: ${DEST}"; exit 1; }

# Show plan
#-------------------------------------------------------------------------------

section "Backup plan"
info "Source:      ${SOURCE}"
info "Destination: ${DEST}"
echo ""

echo -e "${BOLD}Directories:${RESET}"
for d in "${INCLUDE[@]}"; do
    if [[ -e "${HOME}/${d}" ]]; then echo -e "  ${GREEN}✓${RESET} ${d}"
    else                             echo -e "  ${YELLOW}?${RESET} ${d} ${DIM}(not found locally, will be skipped)${RESET}"
    fi
done

echo ""
echo -e "${BOLD}Excluding:${RESET}"
for e in "${EXCLUDE[@]}"; do echo -e "  ${RED}✗${RESET} ${e}"; done

echo ""
info "Free space on destination: $(df -h "${MOUNT_POINT}" | awk 'NR==2 {print $4}')"
$USE_CHECKSUM && info "Conflict detection: checksum (slower, accurate)"

# Logging setup
#-------------------------------------------------------------------------------

mkdir -p "${LOG_DIR}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${LOG_DIR}/backup_${TIMESTAMP}.log"

# Helpers
#-------------------------------------------------------------------------------

# Append rsync filter rules to a named array. Include patterns are anchored
# with a leading /. For nested paths (e.g. Projects/myproject), parent
# directories are included with a trailing / so rsync can descend into them
# without picking up siblings. Excludes are listed first so they apply within
# included directories.
build_filter_args() {
    local -n _arr=$1
    for excl in "${EXCLUDE[@]}"; do
        _arr+=(--exclude="${excl}")
    done
    for dir in "${INCLUDE[@]}"; do
        # For nested paths (e.g. Projects/myproject), rsync must be allowed to
        # traverse each parent directory or --exclude=* will block descent.
        local part=""
        local IFS="/"
        read -ra segments <<< "${dir}"
        for (( i=0; i < ${#segments[@]}-1; i++ )); do
            part="${part}${part:+/}${segments[$i]}"
            _arr+=(--include="/${part}/")
        done
        unset IFS
        _arr+=(--include="/${dir}/***")
    done
    _arr+=(--exclude="*")
}

COMMON_RSYNC=(
    --no-perms --no-owner --no-group
    --modify-window=1
    --human-readable
)

# Phase 1: detect conflicts
#-------------------------------------------------------------------------------
#
# A conflict is any file present on both sides with a differing size or mtime.
# We don't care which side is newer — any divergence needs a decision.
#
# Strategy: dry-run rsync --itemize-changes and collect ">f" (would-transfer)
# entries. For each, confirm the destination file actually exists — if it does,
# the file diverges and is a conflict. If it doesn't, it's simply a new file
# and will be copied unconflicted in phase 3.

section "Phase 1/3 — Scanning for conflicts"
echo ""

DETECT_ARGS=(
    "${COMMON_RSYNC[@]}"
    --dry-run
    --archive
    --itemize-changes
    --out-format="%i %n"
)
$USE_CHECKSUM && DETECT_ARGS+=(--checksum)
build_filter_args DETECT_ARGS

ITEMIZED="$(rsync "${DETECT_ARGS[@]}" "${SOURCE}" "${DEST}" 2>/dev/null || true)"

declare -a CONFLICTS=()

while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    flags="${line%% *}"
    relpath="${line#* }"

    # ">f" = rsync intends to send this regular file to the destination
    [[ "${flags}" != \>f* ]] && continue

    src="${HOME}/${relpath}"
    dst="${DEST}${relpath}"

    # Source must exist (sanity check) and destination must also exist —
    # if dest is absent this is a new file, not a conflict.
    [[ -f "${src}" ]] || continue
    [[ -f "${dst}" ]] && CONFLICTS+=("${relpath}")
done <<< "${ITEMIZED}"

CONFLICT_COUNT="${#CONFLICTS[@]}"

if (( CONFLICT_COUNT == 0 )); then
    success "No conflicts found"
else
    echo -e "  ${YELLOW}${BOLD}${CONFLICT_COUNT} conflict(s) found${RESET}" \
            "${DIM}— file exists on both sides but differs in size or mtime${RESET}"
fi

# Phase 2: resolve conflicts
#-------------------------------------------------------------------------------
#
# Resolution options:
#   source → overwrite destination with local file (rsync will transfer it)
#   dest   → keep destination as-is (exclude this path from the rsync run)

declare -A RESOLUTION=()  # relpath → "source" | "dest"

if (( CONFLICT_COUNT > 0 )); then
    section "Phase 2/3 — Conflict resolution"

    if $NO_CONFLICT_PROMPT; then
        warn "--no-conflict-prompt set: keeping destination for all ${CONFLICT_COUNT} conflict(s)"
        for f in "${CONFLICTS[@]}"; do
            RESOLUTION["${f}"]="dest"
        done
    else
        echo ""
        echo -e "  A conflict means the file differs between your machine and the backup."
        echo -e "  ${DIM}Both sides are left untouched unless you explicitly choose source.${RESET}"
        echo ""
        echo -e "  ${BOLD}[s]${RESET} keep ${GREEN}Source${RESET}   overwrite destination with your local file"
        echo -e "  ${BOLD}[d]${RESET} keep ${CYAN}Dest${RESET}     leave destination file as-is"
        echo ""
        echo -e "  Batch:  ${BOLD}[S]${RESET} source-all   ${BOLD}[D]${RESET} dest-all"
        echo ""
        hr

        BATCH=""

        for i in "${!CONFLICTS[@]}"; do
            f="${CONFLICTS[$i]}"
            src="${HOME}/${f}"
            dst="${DEST}${f}"
            num="$(( i + 1 ))/${CONFLICT_COUNT}"

            # Batch fast-path
            if [[ -n "${BATCH}" ]]; then
                RESOLUTION["${f}"]="${BATCH}"
                case "${BATCH}" in
                    source) echo -e "  ${DIM}[${num}]${RESET} ${GREEN}source ${RESET} ${DIM}${f}${RESET}" ;;
                    dest)   echo -e "  ${DIM}[${num}]${RESET} ${CYAN}dest   ${RESET} ${DIM}${f}${RESET}" ;;
                esac
                continue
            fi

            # Per-file metadata
            src_time=$(stat -c "%y" "${src}" 2>/dev/null | cut -d. -f1 || echo "unknown")
            dst_time=$(stat -c "%y" "${dst}" 2>/dev/null | cut -d. -f1 || echo "unknown")
            src_size=$(stat -c "%s" "${src}" 2>/dev/null | numfmt --to=iec 2>/dev/null || echo "?")
            dst_size=$(stat -c "%s" "${dst}" 2>/dev/null | numfmt --to=iec 2>/dev/null || echo "?")

            echo ""
            echo -e "  ${BOLD}[${num}]${RESET} ${MAGENTA}${f}${RESET}"
            echo -e "    ${GREEN}source${RESET}  ${src_size}  ${DIM}${src_time}${RESET}"
            echo -e "    ${CYAN}dest  ${RESET}  ${dst_size}  ${DIM}${dst_time}${RESET}"
            echo ""

            while true; do
                read -rn1 -p "  [s/d/S/D] › " choice; echo
                case "${choice}" in
                    s) RESOLUTION["${f}"]="source"; echo -e "  ${GREEN}✓ source${RESET}";                                        break ;;
                    d) RESOLUTION["${f}"]="dest";   echo -e "  ${CYAN}✓ dest${RESET}";                                          break ;;
                    S) RESOLUTION["${f}"]="source"; BATCH="source"; echo -e "  ${GREEN}✓ source — applying to all remaining${RESET}"; break ;;
                    D) RESOLUTION["${f}"]="dest";   BATCH="dest";   echo -e "  ${CYAN}✓ dest — applying to all remaining${RESET}";   break ;;
                    *) echo -e "  ${RED}Please enter s, d, S, or D${RESET}" ;;
                esac
            done

            echo ""
            hr
        done
    fi
fi

# Phase 3: transfer
#-------------------------------------------------------------------------------

section "Phase 3/3 — Transferring files"
echo ""

# Exclude every conflicted file where the resolution is "dest".
# This gives us explicit control — we don't rely on --update semantics
# which would silently skip files based on mtime alone.
CONFLICT_EXCLUDE_ARGS=()
for f in "${!RESOLUTION[@]}"; do
    [[ "${RESOLUTION[$f]}" == "dest" ]] && CONFLICT_EXCLUDE_ARGS+=(--exclude="${f}")
done

RSYNC_ARGS=(
    "${COMMON_RSYNC[@]}"
    --archive
    # No --delete: destination-only files are never removed (fully additive).
    # No --update: conflict exclusions above give us explicit per-file control.
    --partial
    --stats
    --info=progress2
    --no-inc-recursive
    --log-file="${LOG_FILE}"
)

$DRY_RUN      && RSYNC_ARGS+=(--dry-run)
$USE_CHECKSUM && RSYNC_ARGS+=(--checksum)

# Conflict exclusions must precede filter rules (rsync applies rules in order)
RSYNC_ARGS+=("${CONFLICT_EXCLUDE_ARGS[@]}")
build_filter_args RSYNC_ARGS

START_TIME=$(date +%s)

RSYNC_STATS_FILE="$(mktemp)"

if ! $DRY_RUN; then
    info "Running with live progress..."
    echo ""
    rsync "${RSYNC_ARGS[@]}" "${SOURCE}" "${DEST}" \
        2>&1 | tee "${RSYNC_STATS_FILE}" \
             | grep --line-buffered -v "^$" \
             | pv -lbt -N "files" > /dev/null
    RSYNC_EXIT=${PIPESTATUS[0]}
else
    rsync "${RSYNC_ARGS[@]}" "${SOURCE}" "${DEST}" | tee "${RSYNC_STATS_FILE}"
    RSYNC_EXIT=${PIPESTATUS[0]}
fi

END_TIME=$(date +%s)
ELAPSED=$(( END_TIME - START_TIME ))
ELAPSED_FMT=$(printf '%dm %02ds' $((ELAPSED/60)) $((ELAPSED%60)))

# Append to conflict sidecar log on destination
#-------------------------------------------------------------------------------

if (( CONFLICT_COUNT > 0 )) && ! $DRY_RUN; then
    {
        echo "── $(date --iso-8601=seconds)  host=${HOSTNAME_SHORT} ──────────────────────────"
        for f in "${CONFLICTS[@]}"; do
            res="${RESOLUTION[$f]:-dest}"
            printf "  %-10s %s\n" "[${res}]" "${f}"
        done
        echo ""
    } >> "${DEST}${CONFLICT_LOG_ON_DEST}"
fi

# Summary
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}╔════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║             Backup Summary             ║${RESET}"
echo -e "${BOLD}╚════════════════════════════════════════╝${RESET}"
echo ""

if [[ ${RSYNC_EXIT} -eq 0 ]]; then
    success "Completed in ${ELAPSED_FMT}"
elif [[ ${RSYNC_EXIT} -eq 24 ]]; then
    warn "Completed in ${ELAPSED_FMT} ${DIM}(some files changed mid-run — usually harmless)${RESET}"
else
    error "rsync exited with code ${RSYNC_EXIT} — see: ${LOG_FILE}"
fi

# Transfer stats
if [[ -s "${RSYNC_STATS_FILE}" ]]; then
    echo ""
    echo -e "${BOLD}Transfer statistics:${RESET}"
    grep -E "^(Number of files|Number of created|Number of deleted|Total file size|Total transferred file)" \
        "${RSYNC_STATS_FILE}" 2>/dev/null | sed 's/^/  /' || true
fi
rm -f "${RSYNC_STATS_FILE}"

# Conflict summary
if (( CONFLICT_COUNT > 0 )); then
    SOURCE_WINS=0; DEST_WINS=0
    for f in "${!RESOLUTION[@]}"; do
        case "${RESOLUTION[$f]}" in
            source) (( SOURCE_WINS++ )) ;;
            dest)   (( DEST_WINS++ ))   ;;
        esac
    done

    echo ""
    echo -e "${BOLD}Conflicts (${CONFLICT_COUNT} total):${RESET}"
    echo -e "  ${GREEN}source wins:${RESET}   ${SOURCE_WINS}"
    echo -e "  ${CYAN}dest wins:${RESET}     ${DEST_WINS}"

    ! $DRY_RUN && echo "" && info "Conflict log on drive: ${DEST}${CONFLICT_LOG_ON_DEST}"
fi

echo ""
info "Full log: ${LOG_FILE}"
$DRY_RUN && echo "" && warn "DRY RUN — no files were written."

exit ${RSYNC_EXIT}
