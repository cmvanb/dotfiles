---
name: setup-devenv
description: Discover, install, and verify the local development environment of a project. Record the result in `.agents/DEVENV.md` so that any agent can rebuild it unattended. Use when a build, run, or test fails because a tool, SDK, device, service, secret, or config is missing and `.agents/DEVENV.md` is absent. Also use when the user asks to set up the development environment.
---

# Setup Devenv

## Outcome

This skill produces two results:

- A working local environment.
  Every run command and every test tier of the project passes on this host.
- The file `.agents/DEVENV.md` in the main checkout.
  It holds every step that rebuilds this environment on a fresh Arch-family
  machine.

Run this skill one time per project.
After that, agents follow `DEVENV.md` and correct it when a step fails.

## Locate the main checkout

The main checkout holds `DEVENV.md` for all worktrees of the repository.

```bash
MAIN=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
```

If `$MAIN/.agents/DEVENV.md` exists, follow it and stop this skill.

The global rule that names `DEVENV.md` approves writes to these paths in
`$MAIN`: `.agents/`, `mise.local.toml`, `.secrets/`, and `.git/info/exclude`.

## Policy

### Layers

| Layer | Content | Owner |
|---|---|---|
| System | Shared tools that the project leaves unpinned: git, base-devel, docker, mise, netcat | `pacman` or `paru`, in one root block for the user |
| Project | Runtimes and CLIs that the project pins, environment variables, tasks | `mise.local.toml` at the repository root |
| Project convention | Committed version files and wrappers: `.fvmrc`, `rust-toolchain.toml`, `gradlew` | The tool that the project uses |
| User data | SDKs, system images, and devices outside the mise registry | Steps that install into `$XDG_DATA_HOME/<tool>` |

Use these rules to select the layer of a tool:

- If the project pins a version, the tool goes in the project layer.
- If a system package on the host meets the pin, keep that package.
- If the project uses its own version manager, that manager installs the tool.
  mise adds the path, for example `_.path = ["{{config_root}}/.fvm/flutter_sdk/bin"]`.
- If a version file names the version, copy the version into `[tools]`.
  mise reads `.nvmrc`, `.python-version`, and `engines` only with extra settings.
- If CI pins a CLI version, use the CI pin, for example `"npm:firebase-tools" = "15.33.0"`.

### Commands

- Agents run every project command as `mise exec -- <command>` or `mise run <task>`.
- Interactive shells load the same environment through the `mise activate` hook.
- Define each run command, service, device, and test tier as a task in `mise.local.toml`.
- Name the tasks `run`, `test:<tier>`, `test`, `<service>:start`, and `<service>:stop`.
- If the project has a test runner, each tier task calls the runner.
  Use the tier names of the runner.
- The task `test` runs the tiers in sequence.
  Use `run = [{ task = "test:<tier>" }, ...]`, because `depends` runs tasks in parallel.
  If the runner has a mode for all tiers, `test` calls that mode.
- Merge tiers that test the same code.

### Existing `.envrc` files

Translate the `.envrc` lines that a run command or a test tier needs.
Ask the user about each other line.
Keep production credentials out of the project environment.

| `.envrc` | `mise.local.toml` |
|---|---|
| `export NAME=value` | `NAME = "value"` |
| `export NAME="$PWD/x"` | `NAME = "{{config_root}}/x"` |
| `export NAME="${VAR:-default}"` | `NAME = "${VAR:-default}"` |
| `PATH_add bin` | `_.path = ["bin"]`, with all paths in one array |
| `dotenv .env` | `_.file = ".env"` |
| `source script.sh` | `_.source = "script.sh"` |
| `layout python` or `activate_venv .venv` | `_.python.venv = ".venv"` |

Leave the `.envrc` file unchanged.
If a line exports a secret value, put the value into `.secrets/` and load it from there.

### Local files

These local files stay out of version control:

- `.agents/`
- `mise.local.toml`
- `.secrets/`
- Symlinks that point into `.secrets/`
- Downloaded public config files

The global git ignore covers `.agents/`, `mise.local.toml`, and `.secrets/`.
For each other local file, run `git check-ignore -q <path>`.
If the command fails, append the path to `$MAIN/.git/info/exclude`.

### Credentials

Classify each credential that a run command or a test tier reads.

| Kind | Examples | Action | `DEVENV.md` section |
|---|---|---|---|
| Account | `az login`, `firebase login`, `gcloud auth application-default login` | Log in. Record the login command and a check. | Accounts |
| Public config | `google-services.json`, `GoogleService-Info.plist`, a web client config | Download it with its CLI to the path that the tool reads. | Public config |
| Local value | An emulator project ID, a fake API key, a local database URL | Write it in `[env]` of `mise.local.toml`. | Project toolchain |
| Secret | An API token, a service account key, a signing key | Store it in `.secrets/`. | Secrets |

Run test tiers against local services with local values when the project supports it.

### Secrets

- Secret values live in `$MAIN/.secrets/`.
  `DEVENV.md` and `mise.local.toml` hold names and paths only.
- Put environment secrets in `.secrets/<name>.env`.
  Load them with `_.file = { path = ".secrets/<name>.env", redact = true }`.
- If a tool reads a secret from a fixed path, store the file in `.secrets/`.
  Then make a symlink at the fixed path.
- If the project has a secret tool, the tool gets each value.
  Examples are `fnox.toml`, a SOPS file, and references for `op`, `doppler`, `infisical`, or `vault`.
  Record the get command of the tool.
- Otherwise, the user gives each value in the question batch.
  Record "the user" as the source.
  Report that the project needs a secret store.
- Store each secret that a run command or a test tier needs.
  List the other secrets by name as optional.

## Workflow

### 1. Discover

Read the project and the host before you ask anything.
CI config is the most accurate source for versions and commands.

Read these project sources:

- `README*`, `CONTRIBUTING*`, `AGENTS.md`, `CLAUDE.md`, and `docs/`
- Manifests and lockfiles: `package.json`, `pubspec.yaml`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `*.csproj`, `build.gradle*`, `Gemfile`
- Version pins: `.fvmrc`, `.nvmrc`, `.python-version`, `.tool-versions`, `rust-toolchain.toml`, `global.json`, `engines` fields
- CI config: `.github/workflows/`, `azure-pipelines*.yml`, `.gitlab-ci.yml`, `.circleci/`
- Task runners: `Makefile`, `justfile`, `Taskfile.yml`, `scripts/`, `package.json` scripts
- Containers and services: `Dockerfile*`, `compose*.yml`, `.devcontainer/`, `firebase.json`
- Test directories and test config, for each language in the repository
- Secret hints: `.env.example`, ignored paths in `.gitignore`, secret names in CI config
- Existing local files: `.envrc`, `mise.local.toml`, `.secrets/`

List every external command that the scripts and the CI steps call.
Examples are `nc`, `jq`, and `adb`.

Read these host facts:

```bash
hostnamectl
command -v <each external command>
command -v mise && mise ls
ls "$XDG_DATA_HOME"
env | grep -i -E '<tool>|_HOME|_ROOT'
test -r /dev/kvm -a -w /dev/kvm && echo kvm-ok
systemctl is-active docker
ss -ltn
```

Also read the login state of each CLI that the project uses.
Examples are `gh auth status`, `az account show`, `firebase login:list`, and `gcloud auth list`.

If a host variable conflicts with the project, unset it in `[env]` with `NAME = false`.

Make an inventory from the discovery:

- Runtimes and their versions
- CLIs and SDKs
- SDK components, from the build files, for example compile SDK and NDK versions
- Services and devices, with their ports
- Credentials, the kind of each one, and the path where each one goes
- Run commands
- Test tiers: every tier that CI runs, and every tier that the docs or scripts run locally

### 2. Ask

Ask the user one batch of questions.
Use the question tool of the harness, or one message.
Ask only for facts that only the user knows.
Examples are preferences and secret values that only the user holds.
Put the discovered default first in each option list.

### 3. Collect root steps

Collect every step that needs root.
Examples are packages, group membership, udev rules, and system services.
Give the user one command block that does all of these steps.
Wait for the user to run it.
Then do the check of each root step.

### 4. Install

Do each user-level step as a check, then an action.
Skip the action when the check passes.

1. Log in to each account.
   Download each public config file.
   Get each secret into `.secrets/`.
2. Write `mise.local.toml`.
3. Run `mise trust` in the repository root.
4. Run `mise install`.
5. Install each user-data tool into `$XDG_DATA_HOME/<tool>`.
   Accept SDK licenses with the tool, for example `yes | sdkmanager --licenses`.
6. Create each device, for example an Android virtual device in `$XDG_DATA_HOME/android-avd`.
7. Run the install step of each project convention, for example `fvm install`.
8. Run the dependency install of each package manager, for example `npm ci` or `flutter pub get`.

mise skips a `_.file` that is absent.
Make sure that each file in `_.file` exists before step 4.

### 5. Verify

Run every run command and every test tier through its mise task.
Start each service and device before the tiers that need them.
Stop each service and device after the last tier that needs them.

For a long-running command, wait for its first ready line, then stop it.
For each other command, wait for it to exit.
Record the output line that shows success.

If a tier fails because of the environment, correct the environment and run the tier again.
Continue until every tier passes.
If a tier fails because of project code, tell the user and keep the tier in `DEVENV.md`.

### 6. Write `DEVENV.md`

Write `$MAIN/.agents/DEVENV.md` from
[references/devenv-template.md](references/devenv-template.md).

- Include only steps that you ran and saw succeed.
- Make the file complete without other files.
  Restate facts from committed docs.
- Include the full text of `mise.local.toml`.
- Apply the `markdown` skill, the `simple-english` skill in pragmatic mode, and the global writing style.
- Write positive statements only.
  Describe what the environment contains and does.

### 7. Report

Give the user a short summary:

- The tools, services, devices, accounts, and secrets that you installed
- The test tiers and their results
- Each fact in a committed doc that disagrees with what you saw

Keep every committed file unchanged.

## Correct forward

An agent that follows `DEVENV.md` and finds a failed step corrects the step.
Then the agent updates `DEVENV.md` with the step that works.
