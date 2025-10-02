#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Install user packages on Ubuntu
#-------------------------------------------------------------------------------

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

is_apt_package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

is_ppa_added() {
    grep -h "^deb.*$1" /etc/apt/sources.list.d/* /etc/apt/sources.list 2>/dev/null | grep -q "$1"
}

get_latest_github_version() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'
}

download_file() {
    local url="$1"
    local output="$2"
    log_info "Downloading $(basename "$output")..."
    curl -L --progress-bar "$url" -o "$output"
}

# Install packages from default repositories
#-------------------------------------------------------------------------------
install_apt_packages() {
    local packages=("$@")

    local to_install=()
    for package in "${packages[@]}"; do
        if ! is_apt_package_installed "$package"; then
            to_install+=("$package")
        else
            log_success "$package is already installed"
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        log_info "Installing: ${to_install[*]}"
        DEBIAN_FRONTEND=noninteractive sudo apt install -y "${to_install[@]}"
        log_success "Packages installed: ${to_install[*]}"
    else
        log_success "All specified packages are already installed"
    fi
}

configure_python() {
    if [[ ! -L /usr/bin/python ]]; then
        if [[ ! -e /usr/bin/python ]]; then
            log_info "Creating python -> python3 symlink"
            sudo ln -s /usr/bin/python3 /usr/bin/python
            log_success "Python symlink created"
        else
            log_warning "/usr/bin/python exists but is not a symlink - skipping"
        fi
    else
        log_success "Python symlink already exists"
    fi
}

# Install packages from custom repositories
#-------------------------------------------------------------------------------
install_eza() {
    if command_exists eza; then
        log_success "eza is already installed"
        return
    fi

    log_info "Setting up eza repository..."
    sudo mkdir -p /etc/apt/keyrings

    if [[ ! -f /etc/apt/keyrings/gierens.gpg ]]; then
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/gierens.list ]]; then
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    fi
}

install_fish() {
    if command_exists fish; then
        log_success "fish is already installed"
        return
    fi

    log_info "Adding fish shell repository..."
    if ! is_ppa_added "fish-shell/release-4"; then
        sudo add-apt-repository -y ppa:fish-shell/release-4
    else
        log_success "Fish PPA already added"
    fi
}

install_neovim() {
    if command_exists nvim; then
        log_success "neovim is already installed"
        return
    fi

    log_info "Adding neovim repository..."
    if ! is_ppa_added "neovim-ppa/unstable"; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
    else
        log_success "Neovim PPA already added"
    fi
}

install_ytdlp() {
    if command_exists yt-dlp; then
        log_success "yt-dlp is already installed"
        return
    fi

    log_info "Adding yt-dlp repository..."
    if ! is_ppa_added "tomtomtom/yt-dlp"; then
        sudo add-apt-repository ppa:tomtomtom/yt-dlp
    else
        log_success "yt-dlp PPA already added"
    fi
}

install_custom_repo_packages() {
    install_eza
    install_fish
    install_neovim
    install_ytdlp

    sudo apt update

    local packages=(eza fish neovim)
    local to_install=()

    for package in "${packages[@]}"; do
        if ! is_apt_package_installed "$package"; then
            to_install+=("$package")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        log_info "Installing custom repository packages: ${to_install[*]}"
        DEBIAN_FRONTEND=noninteractive sudo apt install -y "${to_install[@]}"
        log_success "Custom repository packages installed"
    else
        log_success "All custom repository packages are already installed"
    fi
}

# Install packages manually
#-------------------------------------------------------------------------------
install_deb_package() {
    local name="$1"
    local repo="$2"
    local deb_pattern="$3"

    if command_exists "$name"; then
        log_success "$name is already installed"
        return
    fi

    log_info "Installing $name..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "$repo")
    local deb_file
    deb_file=$(echo "$deb_pattern" | sed "s/{VERSION}/$version/g")
    local url="https://github.com/$repo/releases/download/v$version/$deb_file"

    download_file "$url" "$deb_file"
    sudo DEBIAN_FRONTEND=noninteractive dpkg -i "$deb_file" || {
        log_warning "dpkg failed, trying to fix dependencies..."
        sudo apt-get install -f -y
    }
    rm -f "$deb_file"

    popd >/dev/null
    log_success "$name installed"
}

install_bat() {
    install_deb_package "bat" "sharkdp/bat" "bat_{VERSION}_amd64.deb"
}

install_delta() {
    install_deb_package "delta" "dandavison/delta" "git-delta_{VERSION}_amd64.deb"
}

install_direnv() {
    if command_exists direnv; then
        log_success "direnv is already installed"
        return
    fi

    log_info "Installing direnv..."
    curl -sfL https://direnv.net/install.sh | bash
    log_success "direnv installed"
}

install_esh() {
    if command_exists esh; then
        log_success "esh is already installed"
        return
    fi

    log_info "Installing esh..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "jirutka/esh")
    local archive="esh-$version.tar.gz"
    local url="https://github.com/jirutka/esh/archive/v$version/$archive"

    download_file "$url" "$archive"

    local esh_dir="esh-build-$$"
    mkdir -p "$esh_dir"
    tar -xzf "$archive" -C "$esh_dir" --strip-components=1

    pushd "$esh_dir" >/dev/null
    sudo make install prefix=/usr/local DESTDIR=/
    popd >/dev/null

    rm -rf "$esh_dir" "$archive"
    popd >/dev/null
    log_success "esh installed"
}

install_fd() {
    install_deb_package "fd" "sharkdp/fd" "fd_{VERSION}_amd64.deb"
}

install_fnm() {
    if command_exists fnm; then
        log_success "fnm is already installed"
        return
    fi

    log_info "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash
    log_success "fnm installed"
}

install_fzf() {
    if command_exists fzf; then
        log_success "fzf is already installed"
        return
    fi

    log_info "Installing fzf..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "junegunn/fzf")
    local archive="fzf-$version-linux_amd64.tar.gz"
    local url="https://github.com/junegunn/fzf/releases/download/v$version/$archive"

    download_file "$url" "$archive"

    local fzf_dir="fzf-build-$$"
    mkdir -p "$fzf_dir"
    tar -xzf "$archive" -C "$fzf_dir"
    sudo mv "$fzf_dir/fzf" /usr/bin/

    rm -rf "$fzf_dir" "$archive"
    popd >/dev/null
    log_success "fzf installed"
}

install_neo() {
    if command_exists neo; then
        log_success "neo is already installed"
        return
    fi

    log_info "Installing neo..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "st3w/neo")
    local archive="neo-$version.tar.gz"
    local url="https://github.com/st3w/neo/releases/download/v$version/$archive"

    download_file "$url" "$archive"

    local neo_dir="neo-build-$$"
    mkdir -p "$neo_dir"
    tar -xzf "$archive" -C "$neo_dir" --strip-components=1

    pushd "$neo_dir" >/dev/null
    ./configure
    make -j$(nproc)
    sudo make install
    popd >/dev/null

    rm -rf "$neo_dir" "$archive"
    popd >/dev/null
    log_success "neo installed"
}

install_rbw() {
    if command_exists rbw; then
        log_success "rbw is already installed"
        return
    fi

    log_info "Installing rbw..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "doy/rbw")
    local deb_file="rbw_${version}_amd64.deb"
    local url="https://git.tozt.net/rbw/releases/deb/$deb_file"

    download_file "$url" "$deb_file"
    sudo DEBIAN_FRONTEND=noninteractive dpkg -i "$deb_file" || {
        log_warning "dpkg failed, trying to fix dependencies..."
        sudo apt-get install -f -y
    }
    rm -f "$deb_file"

    popd >/dev/null
    log_success "rbw installed"
}

install_ripgrep() {
    install_deb_package "rg" "BurntSushi/ripgrep" "ripgrep_{VERSION}-1_amd64.deb"
}

install_rustup() {
    if command_exists rustup; then
        log_success "rustup is already installed"
        return
    fi

    log_info "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
    log_success "rustup installed"
}

install_yazi() {
    if command_exists yazi; then
        log_success "yazi is already installed"
        return
    fi

    log_info "Installing yazi..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "sxyazi/yazi")
    local archive="yazi-x86_64-unknown-linux-gnu.zip"
    local url="https://github.com/sxyazi/yazi/releases/download/v$version/$archive"

    download_file "$url" "$archive"

    local yazi_dir="yazi-build-$$"
    mkdir -p "$yazi_dir"
    unzip -q "$archive" -d "$yazi_dir"

    sudo mv "$yazi_dir"/yazi-x86_64-unknown-linux-gnu/yazi /usr/bin/
    sudo mv "$yazi_dir"/yazi-x86_64-unknown-linux-gnu/ya /usr/bin/

    rm -rf "$yazi_dir" "$archive"
    popd >/dev/null
    log_success "yazi installed"
}

install_zig() {
    if command_exists zig; then
        log_success "zig is already installed"
        return
    fi

    log_info "Installing zig..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "ziglang/zig")
    local archive="zig-x86_64-linux-$version.tar.xz"
    local url="https://ziglang.org/download/$version/$archive"

    download_file "$url" "$archive"

    local zig_dir="zig-build-$$"
    mkdir -p "$zig_dir"
    tar -xf "$archive" -C "$zig_dir" --strip-components=1

    sudo mv "$zig_dir/zig" /usr/bin/

    rm -rf "$zig_dir" "$archive"
    popd >/dev/null
    log_success "zig installed"
}

install_zoxide() {
    if command_exists zoxide; then
        log_success "zoxide is already installed"
        return
    fi

    log_info "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    log_success "zoxide installed"
}

# Install desktop environment packages
#-------------------------------------------------------------------------------

install_floorp_ppa() {
    if command_exists floorp; then
        log_success "Floorp is already installed"
        return
    fi

    log_info "Installing floorp..."

    if [[ ! -f /etc/apt/keyrings/floorp.gpg ]]; then
        curl -fsSL https://ppa.floorp.app/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/floorp.list ]]; then
        sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list "https://ppa.floorp.app/Floorp.list"
    fi

    sudo apt update

    DEBIAN_FRONTEND=noninteractive sudo apt install -y floorp

    log_success "Floorp installed"
}

install_floorp_gh() {
    if command_exists floorp; then
        log_success "Floorp is already installed"
        return
    fi

    log_info "Installing Floorp..."

    pushd /tmp >/dev/null

    # Download
    local version
    version=$(get_latest_github_version "Floorp-Projects/Floorp")
    local archive="floorp-linux-amd64.tar.xz"
    local url="https://github.com/Floorp-Projects/Floorp/releases/download/v$version/$archive"
    download_file "$url" "$archive"

    # Extract
    local floorp_dir="floorp-build-$$"
    mkdir -p "$floorp_dir"
    tar -xf "$archive" -C "$floorp_dir"

    # Install
    if [[ -d /opt/floorp ]]; then
        sudo rm -rf /opt/floorp
    fi
    sudo mv "$floorp_dir/floorp" /opt
    if [[ -L /usr/bin/floorp ]]; then
        sudo rm /usr/bin/floorp
    fi
    if [[ -L /usr/bin/floorp-bin ]]; then
        sudo rm /usr/bin/floorp-bin
    fi
    sudo ln -s /opt/floorp/floorp /usr/bin/floorp
    sudo ln -s /opt/floorp/floorp-bin /usr/bin/floorp-bin

    # Desktop entry
    cat <<-EOF > "$XDG_DATA_HOME/applications/floorp.desktop"
		[Desktop Entry]
		Name=Floorp
		GenericName=Web Browser
		Comment=Browse the web
		Exec=floorp %u
		Icon=floorp
		Terminal=false
		Type=Application
		MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
		StartupNotify=true
		Categories=Network;WebBrowser;
		Keywords=ablaze;web;browser;internet;
		Actions=new-window;new-private-window;profile-manager-window;
		StartupWMClass=floorp
		
		[Desktop Action new-window]
		Name=Open a New Window
		Exec=floorp --new-window %u
		
		[Desktop Action new-private-window]
		Name=Open a New Private Window
		Exec=floorp --private-window %u
		
		[Desktop Action profile-manager-window]
		Name=Open the Profile Manager
		Exec=floorp --ProfileManager
	EOF

    # Icons
    local icons_dir="floorp-icons-$$"
    git clone --depth=1 --filter=blob:none --sparse \
        https://github.com/Floorp-Projects/Floorp.git "$icons_dir"

    pushd "$icons_dir" >/dev/null
    git sparse-checkout set gecko/branding/floorp-official

    # Install icons to system directories
    sudo mkdir -p /usr/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps

    local branding_dir="gecko/branding/floorp-official"
    if [[ -f "$branding_dir/default16.png" ]]; then
        sudo cp "$branding_dir/default16.png" /usr/share/icons/hicolor/16x16/apps/floorp.png
    fi
    if [[ -f "$branding_dir/default32.png" ]]; then
        sudo cp "$branding_dir/default32.png" /usr/share/icons/hicolor/32x32/apps/floorp.png
    fi
    if [[ -f "$branding_dir/default48.png" ]]; then
        sudo cp "$branding_dir/default48.png" /usr/share/icons/hicolor/48x48/apps/floorp.png
    fi
    if [[ -f "$branding_dir/default64.png" ]]; then
        sudo cp "$branding_dir/default64.png" /usr/share/icons/hicolor/64x64/apps/floorp.png
    fi
    if [[ -f "$branding_dir/default128.png" ]]; then
        sudo cp "$branding_dir/default128.png" /usr/share/icons/hicolor/128x128/apps/floorp.png
    fi
    if [[ -f "$branding_dir/default256.png" ]]; then
        sudo cp "$branding_dir/default256.png" /usr/share/icons/hicolor/256x256/apps/floorp.png
    fi

    popd >/dev/null
    rm -rf "$icons_dir"

    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor/ 2>/dev/null || true

    rm -rf "$floorp_dir" "$archive"
    popd >/dev/null
    log_success "Floorp installed"
}

install_ghostty() {
    if command_exists ghostty; then
        log_success "ghostty is already installed"
        return
    fi

    log_info "Installing ghostty..."
    curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh | bash
    log_success "ghostty installed"
}

install_gtk_theme() {
    local theme_dir="/usr/share/themes/Qogir-Round-Dark"

    if [[ -d "$theme_dir" ]]; then
        log_success "GTK theme is already installed"
        return
    fi

    log_info "Installing GTK theme..."
    pushd /tmp >/dev/null

    local repo_dir="qogir-theme-$$"
    git clone --depth=1 https://github.com/vinceliuice/Qogir-theme.git "$repo_dir"

    pushd "$repo_dir" >/dev/null
    sudo ./install.sh --tweaks round -c dark -d /usr/share/themes
    popd >/dev/null

    rm -rf "$repo_dir"
    popd >/dev/null
    log_success "GTK theme installed"
}

# Install intelic packages
#-------------------------------------------------------------------------------

install_protolint() {
    if command_exists protolint; then
        log_success "protolint is already installed"
        return
    fi

    log_info "Installing protolint..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "yoheimuta/protolint")
    local archive="protolint_${version}_linux_amd64.tar.gz"
    local url="https://github.com/yoheimuta/protolint/releases/download/v$version/$archive"

    download_file "$url" "$archive"

    local protolint_dir="protolint-build-$$"
    mkdir -p "$protolint_dir"
    tar -xzf "$archive" -C "$protolint_dir"

    sudo mv "$protolint_dir/protolint" /usr/bin/

    rm -rf "$protolint_dir" "$archive"
    popd >/dev/null
    log_success "protolint installed"
}

install_qgroundcontrol() {
    if command_exists QGroundControl; then
        log_success "QGroundControl is already installed"
        return
    fi

    log_info "Installing QGroundControl..."
    pushd /tmp >/dev/null

    local version
    version=$(get_latest_github_version "mavlink/qgroundcontrol")
    local archive="QGroundControl-x86_64.AppImage"
    local url="https://github.com/mavlink/qgroundcontrol/releases/download/v${version}/${archive}"

    download_file "$url" "$archive"

    sudo mv "$archive" /usr/local/bin/QGroundControl
    sudo chmod +x /usr/local/bin/QGroundControl

    cat <<-EOF > "$XDG_DATA_HOME/applications/qgroundcontrol.desktop"
		[Desktop Entry]
		Name=QGroundControl
		Comment=Ground Control Station for Drones
		Exec=/usr/local/bin/QGroundControl
		Icon=qgroundcontrol
		Terminal=false
		Type=Application
		Categories=Utility;Application;
	EOF

    popd >/dev/null
    log_success "QGroundControl installed"
}

install_intelic_packages() {
    # Nexus dependencies
    # QGroundControl dependencies
    install_apt_packages \
        libfontconfig1-dev \
        gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl \
        libfuse2 libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor-dev

    install_protolint
    install_qgroundcontrol
    # TODO: add pnpm
}

# Entry point
#-------------------------------------------------------------------------------
main() {
    log_info "Installing software for Ubuntu"
    log_info "--------------------------------------------------------------------------------"

    log_info "Updating package lists..."
    sudo apt update

    log_info "Installing regular packages..."
    install_apt_packages \
        curl make pkg-config zip unzip wl-clipboard \
        python3 python3-dev python3-pip python3-venv \
        build-essential libncurses-dev \
        asciidoctor \
        mpv
    configure_python

    log_info "Installing custom repository packages..."
    install_custom_repo_packages

    log_info "Installing manually downloaded packages..."
    install_bat
    install_delta
    install_direnv
    install_esh
    install_fd
    install_fnm
    install_fzf
    install_neo
    install_rbw
    install_ripgrep
    install_rustup
    install_yazi
    install_zig
    install_zoxide

    log_info "Installing desktop environment packages..."
    install_floorp_gh
    install_ghostty
    install_gtk_theme

    log_info "Installing intelic packages..."
    install_intelic_packages

    log_success "Installation script completed successfully!"
}

# Run entry point only if script is executed.
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    main "$@"
fi
