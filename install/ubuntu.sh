#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Install user packages on Ubuntu
#
#   TODO: Check whether packages are already installed.
#   TODO: Retrieve the latest version numbers automatically.
#-------------------------------------------------------------------------------

set -euo pipefail


# Install prerequisite packages from default repositories.
#-------------------------------------------------------------------------------

sudo apt install -y \
    asciidoctor curl make \
    python3 python3-dev python3-pip python3-venv \
    unzip zip \
    wl-clipboard

# Configure python
sudo ln -s /usr/bin/python3 /usr/bin/python


# Install packages from custom repositories.
#-------------------------------------------------------------------------------

# Eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

# Fish
sudo add-apt-repository ppa:fish-shell/release-4

# Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable

sudo apt update
sudo apt install -y eza fish neovim


# Install packages manually.
#-------------------------------------------------------------------------------

pushd /tmp

# Bat
# TODO: Retrieve the latest version number automatically.
curl -LO https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
sudo dpkg -i bat_0.25.0_amd64.deb

# Delta
curl -LO https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb
sudo dpkg -i git-delta_0.18.2_amd64.deb

# Direnv
curl -sfL https://direnv.net/install.sh | bash

# Esh
curl -LO https://github.com/jirutka/esh/archive/v0.3.2/esh-0.3.2.tar.gz
mkdir -p /tmp/esh
tar -xzf esh-0.3.2.tar.gz -C /tmp/esh
pushd esh/esh-0.3.2/
sudo make install prefix=/usr/local DESTDIR=/
popd
rm -r /tmp/esh

# Fd
curl -LO https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
sudo dpkg -i fd_10.2.0_amd64.deb

# Fzf
# TODO: Retrieve the latest version number automatically.
curl -LO https://github.com/junegunn/fzf/releases/download/v0.61.1/fzf-0.61.1-linux_amd64.tar.gz
mkdir -p /tmp/fzf
tar -xzf fzf-0.61.1-linux_amd64.tar.gz -C /tmp/fzf
sudo mv /tmp/fzf/fzf /usr/bin
rm -r /tmp/fzf

# Ghostty
curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh | bash

# Ripgrep
# TODO: Retrieve the latest version number automatically.
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
sudo dpkg -i ripgrep_14.1.1-1_amd64.deb

# Yazi
# TODO: Retrieve the latest version number automatically.
YAZI_VERSION="25.5.31"
curl -LO "https://github.com/sxyazi/yazi/releases/download/v$YAZI_VERSION/yazi-x86_64-unknown-linux-gnu.zip"
unzip yazi-x86_64-unknown-linux-gnu.zip
sudo mv /tmp/yazi-x86_64-unknown-linux-gnu/yazi /usr/bin
sudo mv /tmp/yazi-x86_64-unknown-linux-gnu/ya /usr/bin
rm -r /tmp/yazi-x86_64-unknown-linux-gnu

# ZOxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# NodeJS / NPM / fnm (node version manager)
curl -fsSL https://fnm.vercel.app/install | bash

# Rustup / cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash

popd
