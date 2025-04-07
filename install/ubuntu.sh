#-------------------------------------------------------------------------------
# Install user packages on Ubuntu
#
#   TODO: Add fzf, fd.
#-------------------------------------------------------------------------------

set -euo pipefail


# Install prerequisite packages from default repositories.
#-------------------------------------------------------------------------------

sudo apt install -y asciidoctor make unzip zip


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
make install prefix=/usr/local DESTDIR=/
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

# Ripgrep
# TODO: Retrieve the latest version number automatically.
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
sudo dpkg -i ripgrep_14.1.1-1_amd64.deb

# Yazi
# TODO: Retrieve the latest version number automatically.
curl -LO https://github.com/sxyazi/yazi/releases/download/v25.3.2/yazi-x86_64-unknown-linux-gnu.zip
mkdir -p /tmp/yazi
unzip -d /tmp/yazi yazi-x86_64-unknown-linux-gnu.zip
sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/bin
rm -r /tmp/yazi

# ZOxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# NodeJS / NPM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
nvm install 22

popd
