dotfiles
========

My collection of dotfiles (for vim, tmux, git, etc.)


Install
-------

```bash
curl https://raw.githubusercontent.com/markprzepiora/dotfiles/master/setup.sh | bash
```

This should set everything up on OSX and Ubuntu, and on other Unix systems as
long as you have some dependencies installed.


Customization
-------------

Add **interactive-mode customizations** (such as aliases, color stuff, etc.) to
`~/.zshrc_private`. This will be loaded after the contents of the supplied
`.zshrc` file.

Add **environment-related customizations** (such as PATH customization) to
`~/.zshenv_private`. This will be loaded after the contents of the supplied
`.zshenv` file.


ZSH Dotfile Load Order
----------------------

(From StackOverflow) The ultimate order is:

1. `.zshenv`
2. [`.zprofile` if login]
3. [`.zshrc` if interactive]
4. [`.zlogin` if login]
5. [`.zlogout` when login shells exit].


Windows Bootstrapping
---------------------

Not dotfiles... but next time I set up a Windows PC, here are some useful
instructions.

### Remember

Do NOT let Windows create your account from your Microsoft account. It will
create a user named `markp` and you will spend an unreasonable amount of time
first trying to rename the user, and then, when you give up on that, create a
new user name `Mark`. Instead, just tell Windows to create an offline login to
begin with so you can name it whatever you want.

### Install 1Password

Open Powershell and run:

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/markprzepiora/dotfiles/master/script-windows/install-1password.ps1'))

### Chocolatey

Open PowerShell as an administrator.

Then run:

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Then install:

    choco install -y googlechrome 7zip vlc foobar2000 sublimetext4 steam everything dropbox adobe-creative-cloud autohotkey geforce-experience signal cpu-z geekbench OpenHardwareMonitor sysinternals wiztree zoom discord slack docker-desktop teamviewer

### Final Fantasy XIV

Open Powershell and run:

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/markprzepiora/dotfiles/master/script-windows/install-final-fantasy-xiv.ps1'))

Sync configuration from Dropbox:

    Set-ExecutionPolicy Bypass -Scope Process -Force; PowerShell -File C:\Users\Mark\Dropbox\App-Settings-Sync\Common\ff14.ps1

Then install xivlauncher from https://github.com/goatcorp/FFXIVQuickLauncher/releases

### Manual downloads

Chocolatey does not have definitions for a few things.

- [Twitch Studio](https://spotlight.twitchsvc.net/installer/windows/TwitchStudioSetup-network.exe)
- [Spotify](https://download.scdn.co/SpotifySetup.exe)

### WSL Setup

First install Ubuntu:

    wsl --install -d Ubuntu

Once you get into a bash terminal, install packages we'll need:

    sudo apt-get update --yes &&
    sudo apt-get upgrade --yes &&
    sudo apt-get install --yes -qq parallel wget build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev software-properties-common python2.7 exuberant-ctags libpq-dev redis-server s3cmd phantomjs ncdu silversearcher-ag fd-find pv pigz libsqlite3-dev pcre2-utils direnv &&
    sudo apt-add-repository -y ppa:rael-gc/rvm &&
    sudo apt-get update --yes &&
    sudo apt-get install --yes -qq libssl1.0-dev &&
    (wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -) &&
    (echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null) &&
    sudo apt-get update --yes &&
    sudo apt-get install --yes -qq postgresql-13 libpq-dev &&
    mkdir -p ~/bin &&
    ln -s "$(which fdfind)" ~/bin/fd

If you want to compile the latest tmux:

    sudo apt install -y libevent-dev libncurses-dev
    mkdir -p ~/src
    cd ~/src
    wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
    tar -zxf tmux-3.4.tar.gz
    cd tmux-3.4
    ./configure
    make -j24
    sudo make install
    tmux -V

Install Node v20:

    sudo apt-get install --yes ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudp apt-get update --yes
    sudo apt-get install nodejs -y

Install Neovim if desired:

    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get install -y neovim ripgrep python3 python3-pip
    python3 -m pip install --user --upgrade pynvim
    sudo update-alternatives --install /usr/bin/vi vi $(which nvim) 50

Install chruby:

    rm -rf ~/tmp/chruby-0.3.9 &&
    mkdir -p ~/tmp &&
    wget -O ~/tmp/chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz &&
    tar -xzvf ~/tmp/chruby-0.3.9.tar.gz -C ~/tmp &&
    cd ~/tmp/chruby-0.3.9 &&
    sudo make install

Install Homebrew:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install Heroku:

    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

Install Ruby binaries:

    mkdir -p ~/projects
    git clone git@github.com:markprzepiora/ruby-binaries.git ~/projects/ruby-binaries
    sudo mkdir /opt/rubies
    cd ~/projects/ruby-binaries
    bin/install-rubies-remote

Create some useful links:

    ln -s /mnt/c/Users/Mark/Downloads ~/Downloads
    ln -s /mnt/c/Users/Mark/Dropbox ~/Dropbox
    ln -s /mnt/c/Users/Mark/Desktop ~/Desktop
    ln -s /mnt/c/Users/Mark ~/mnt-Mark

Install dotfiles:

    curl https://raw.githubusercontent.com/markprzepiora/dotfiles/master/setup.sh | bash

Change your shell:

    chsh -s /bin/zsh
