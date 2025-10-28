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

configure_pipx() {
    log_info "Configuring pipx..."
    pipx ensurepath
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

install_syncthing() {
    if command_exists syncthing; then
        log_success "syncthing is already installed"
        return
    fi

    log_info "Setting up syncthing repository..."
    sudo mkdir -p /etc/apt/keyrings

    if [[ ! -f /etc/apt/keyrings/syncthing-archive-keyring.gpg ]]; then
        sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/syncthing.list ]]; then
        echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable-v2" | sudo tee /etc/apt/sources.list.d/syncthing.list
    fi
}

install_custom_repo_packages() {
    install_eza
    install_fish
    install_neovim
    install_ytdlp
    install_syncthing

    sudo apt update

    local packages=(eza fish neovim syncthing)
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

install_sdbus_cpp() {
    if dpkg -l | grep -q "^ii  libsdbus-c++-dev"; then
        log_info "Removing conflicting old libsdbus-c++-dev package..."
        sudo apt remove -y libsdbus-c++-dev libsdbus-c++1
    fi

    local current_version
    current_version=$(pkg-config --modversion sdbus-c++ 2>/dev/null || echo "0.0.0")

    if [[ "$(printf '%s\n' "2.0.0" "$current_version" | sort -V | head -n1)" == "2.0.0" ]]; then
        log_success "sdbus-c++ >= 2.0.0 is already installed (version $current_version)"
        return
    fi

    log_info "Installing sdbus-c++ >= 2.0.0..."

    install_apt_packages libsystemd-dev libexpat1-dev

    pushd /tmp >/dev/null

    local tag="v2.0.0"
    local build_dir="sdbus-cpp-build-$$"

    if git clone --depth 1 -b $tag https://github.com/Kistler-Group/sdbus-cpp.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        mkdir build
        cd build
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
        make -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        sudo make install

        popd >/dev/null
        rm -rf "$build_dir"

        if [[ ! -f /etc/ld.so.conf.d/usr-local.conf ]]; then
            echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/usr-local.conf > /dev/null
            echo "/usr/local/lib/x86_64-linux-gnu" | sudo tee -a /etc/ld.so.conf.d/usr-local.conf > /dev/null
        fi

        sudo ldconfig
        log_success "sdbus-c++ installed"
    else
        log_error "Download failed for sdbus-c++"
    fi

    popd >/dev/null
}

install_hyprutils() {
    if pkg-config --exists hyprutils; then
        log_success "hyprutils is already installed"
        return
    fi

    log_info "Installing hyprutils..."
    pushd /tmp >/dev/null

    local tag="v0.8.2"
    local build_dir="hyprutils-build-$$"

    if git clone -b $tag https://github.com/hyprwm/hyprutils.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
        cmake --build ./build --config Release --target hyprutils -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        sudo cmake --install build

        popd >/dev/null
        rm -rf "$build_dir"
        log_success "hyprutils installed"
    else
        log_error "Download failed for hyprutils"
    fi

    popd >/dev/null
}

install_hyprlang() {
    if pkg-config --exists hyprlang; then
        log_success "hyprlang is already installed"
        return
    fi

    log_info "Installing hyprlang..."
    install_apt_packages gcc-14 g++-14

    pushd /tmp >/dev/null

    local tag="v0.6.4"
    local build_dir="hyprlang-build-$$"

    if git clone --recursive -b $tag https://github.com/hyprwm/hyprlang.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib/x86_64-linux-gnu/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

        cmake --no-warn-unused-cli \
            -DCMAKE_BUILD_TYPE:STRING=Release \
            -DCMAKE_INSTALL_PREFIX:PATH=/usr/local \
            -DCMAKE_C_COMPILER=/usr/bin/gcc-14 \
            -DCMAKE_CXX_COMPILER=/usr/bin/g++-14 \
            -S . -B ./build
        cmake --build ./build --config Release --target hyprlang -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        sudo cmake --install ./build

        popd >/dev/null
        rm -rf "$build_dir"
        log_success "hyprlang installed"
    else
        log_error "Download failed for hyprlang"
    fi

    popd >/dev/null
}

install_hyprwayland_scanner() {
    if command_exists hyprwayland-scanner; then
        log_success "hyprwayland-scanner is already installed"
        return
    fi

    log_info "Installing hyprwayland-scanner..."
    install_apt_packages libpugixml-dev

    pushd /tmp >/dev/null

    local tag="v0.4.5"
    local build_dir="hyprwayland-scanner-build-$$"

    if git clone --recursive -b $tag https://github.com/hyprwm/hyprwayland-scanner.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
        cmake --build build -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        sudo cmake --install build

        popd >/dev/null
        rm -rf "$build_dir"
        log_success "hyprwayland-scanner installed"
    else
        log_error "Download failed for hyprwayland-scanner"
    fi

    popd >/dev/null
}

install_hyprgraphics() {
    if pkg-config --exists hyprgraphics; then
        log_success "hyprgraphics is already installed"
        return
    fi

    log_info "Installing hyprgraphics..."
    install_apt_packages libjpeg-dev libwebp-dev libpng-dev

    pushd /tmp >/dev/null

    local tag="v0.1.5"
    local build_dir="hyprgraphics-build-$$"

    if git clone --recursive -b $tag https://github.com/hyprwm/hyprgraphics.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
        cmake --build ./build --config Release --target hyprgraphics -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        sudo cmake --install ./build

        popd >/dev/null
        rm -rf "$build_dir"
        log_success "hyprgraphics installed"
    else
        log_error "Download failed for hyprgraphics"
    fi

    popd >/dev/null
}

install_hyprlock() {
    if command_exists hyprlock; then
        log_success "hyprlock is already installed"
        return
    fi

    log_info "Installing hyprlock dependencies..."
    install_apt_packages \
        libpam0g-dev libgbm-dev libdrm-dev libmagic-dev libaudit-dev \
        libgl1-mesa-dev \
        libwayland-dev libcairo2-dev libpango1.0-dev libxkbcommon-dev

    install_sdbus_cpp
    install_hyprutils
    install_hyprlang
    install_hyprwayland_scanner
    install_hyprgraphics

    if [[ ! -f /etc/ld.so.conf.d/usr-local.conf ]]; then
        echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/usr-local.conf > /dev/null
        echo "/usr/local/lib/x86_64-linux-gnu" | sudo tee -a /etc/ld.so.conf.d/usr-local.conf > /dev/null
    fi

    sudo ldconfig

    log_info "Building hyprlock..."

    local old_sdbus_moved=false
    if [[ -f /lib/x86_64-linux-gnu/libsdbus-c++.so.1 ]]; then
        log_info "Temporarily moving conflicting libsdbus-c++.so.1..."
        sudo mv /lib/x86_64-linux-gnu/libsdbus-c++.so.1 /lib/x86_64-linux-gnu/libsdbus-c++.so.1.backup 2>/dev/null && old_sdbus_moved=true
        sudo mv /lib/x86_64-linux-gnu/libsdbus-c++.so /lib/x86_64-linux-gnu/libsdbus-c++.so.backup 2>/dev/null
        sudo ldconfig
    fi

    pushd /tmp >/dev/null

    local tag="v0.9.1"
    local build_dir="hyprlock-build-$$"

    if git clone --recursive -b $tag https://github.com/hyprwm/hyprlock.git "$build_dir"; then
        pushd "$build_dir" >/dev/null

        rm -f src/auth/Fingerprint.cpp src/auth/Fingerprint.hpp
        sed -i '/#include.*Fingerprint.hpp/d' src/auth/Auth.cpp
        sed -i '/#include.*Fingerprint.hpp/d' src/core/hyprlock.cpp
        sed -i '1i#include <algorithm>' src/auth/Auth.cpp
        sed -i '/ENABLEFINGERPRINT/,/makeShared<CFingerprint>()/d' src/auth/Auth.cpp
        sed -i 's/std::ranges::any_of/std::any_of/g' src/auth/Auth.cpp
        sed -i 's|return std::any_of.*|return std::any_of(m_vImpls.begin(), m_vImpls.end(), [](const auto\& i) { return i->checkWaiting(); });|' src/auth/Auth.cpp
        sed -i '/fingerprintAuth.*g_pAuth->getImpl/d' src/core/hyprlock.cpp
        sed -i '/dbusConn.*CFingerprint/d' src/core/hyprlock.cpp
        sed -i 's/fdcount = dbusConn ? 2 : 1/fdcount = 1/g' src/core/hyprlock.cpp
        sed -i '/if (dbusConn) {/,/^    }/d' src/core/hyprlock.cpp
        sed -i '/if (pollfds\[1\]\.revents.*dbus/,/^        }/d' src/core/hyprlock.cpp

        export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib/x86_64-linux-gnu/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
        export LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

        cmake --no-warn-unused-cli \
            -DCMAKE_BUILD_TYPE:STRING=Release \
            -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
            -DCMAKE_C_COMPILER=/usr/bin/gcc-14 \
            -DCMAKE_CXX_COMPILER=/usr/bin/g++-14 \
            -DCMAKE_PREFIX_PATH=/usr/local \
            -DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib" \
            -S . -B ./build
        cmake --build ./build --config Release --target hyprlock -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
        cmake --install build

        popd >/dev/null
        rm -rf "$build_dir"
        log_success "hyprlock installed"
    else
        log_error "Download failed for hyprlock"
    fi

    if [[ "$old_sdbus_moved" == "true" ]]; then
        log_info "Restoring old libsdbus-c++ libraries..."
        sudo mv /lib/x86_64-linux-gnu/libsdbus-c++.so.1.backup /lib/x86_64-linux-gnu/libsdbus-c++.so.1 2>/dev/null
        sudo mv /lib/x86_64-linux-gnu/libsdbus-c++.so.backup /lib/x86_64-linux-gnu/libsdbus-c++.so 2>/dev/null
        sudo ldconfig
    fi

    popd >/dev/null
}

install_simp1e_cursor_theme() {
    local theme_dir="/usr/share/icons/Simp1e"

    if [[ -d "$theme_dir" ]]; then
        log_success "Simp1e cursor theme is already installed"
        return
    fi

    log_info "Installing Simp1e cursor theme..."
    pushd /tmp >/dev/null

    local files
    files=$(curl -Lfs https://www.pling.com/p/1932768/loadFiles)
    local raw_url
    raw_url=$(echo $files | jq -r '.files[] | select(.name == "Simp1e.tar.xz") | .url')
    local decoded_url
    decoded_url=$(echo $raw_url | perl -pe 's/\%(\w\w)/chr hex $1/ge')

    download_file "$decoded_url" "Simp1e.tar.xz"

    local extract_dir="simp1e-cursor-$$"
    mkdir -p "$extract_dir"
    tar -xf Simp1e.tar.xz -C "$extract_dir"

    sudo mv "$extract_dir/Simp1e" /usr/share/icons/

    rm -rf "$extract_dir" Simp1e.tar.xz
    popd >/dev/null
    log_success "Simp1e cursor theme installed"
}

install_sway() {
    if command_exists sway; then
        log_success "sway is already installed"
        return
    fi

    log_info "Installing sway..."
    install_apt_packages \
        sway waybar fuzzel mako-notifier

    cargo install sway-workspace
    pipx install autotiling

    log_success "sway installed"
}

install_waypaper() {
    if command_exists waypaper; then
        log_success "waypaper is already installed"
        return
    fi

    # Waypaper dependencies
    install_apt_packages \
        libcairo2-dev libgirepository1.0-dev gir1.2-gtk-4.0 \
        gir1.2-girepository-2.0-dev libgirepository-2.0-dev

    log_info "Installing waypaper..."
    pipx install waypaper
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
        curl make pkg-config gcc \
        zip unzip wl-clipboard \
        python3 python3-dev python3-pip python3-venv \
        pipx \
        build-essential libncurses-dev \
        asciidoctor \
        mpv \
        zathura
    configure_pipx
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
    install_ghostty
    install_gtk_theme
    install_hyprlock
    install_simp1e_cursor_theme
    install_sway
    install_waypaper

    log_info "Installing intelic packages..."
    install_intelic_packages

    log_info "Configuring GNOME settings..."
    gsettings set org.gnome.desktop.session idle-delay 3600

    log_success "Installation script completed successfully!"
}

# Run entry point only if script is executed.
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    main "$@"
fi
