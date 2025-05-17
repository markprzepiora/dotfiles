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
    sudo apt-get install --yes -qq parallel wget build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev software-properties-common exuberant-ctags libpq-dev s3cmd ncdu silversearcher-ag fd-find pv pigz libsqlite3-dev pcre2-utils direnv python3 python-is-python3 postgresql-common &&
    sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y &&
    sudo apt-get update --yes &&
    sudo apt-get install --yes -qq postgresql-17 libpq-dev &&
    mkdir -p ~/bin &&
    ln -s "$(which fdfind)" ~/bin/fd &&
    sudo locale-gen en_US en_US.UTF-8 && sudo update-locale

Redis:

    sudo apt-get install lsb-release curl gpg &&
    (curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg) &&
    sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg &&
    (echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list) &&
    sudo apt-get update &&
    sudo apt-get install redis

If you want to compile the latest tmux:

    sudo apt install -y libevent-dev libncurses-dev &&
    mkdir -p ~/src &&
    cd ~/src &&
    wget https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz &&
    tar -zxf tmux-3.5a.tar.gz &&
    cd tmux-3.5a &&
    ./configure &&
    make -j24 &&
    sudo make install &&
    tmux -V

If the final command outputs a different version of tmux, then restart your shell.

Install fnm:

    curl -o- https://fnm.vercel.app/install | bash

Run zsh, and install Node.js:

    fnm install 22

Install 1Password:

    (curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg) &&
    (echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list) &&
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ &&
    (curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol) &&
    (sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22) &&
    (curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg) &&
    sudo apt update &&
    sudo apt install 1password

Run 1password, log in, and enable "Integrate with 1Password CLI" in the Developer tab in Settings.

    nohup 1password &

Install Neovim:

    sudo add-apt-repository -y ppa:neovim-ppa/unstable &&
    sudo apt-get install -y neovim ripgrep python3 python3-pip python3-pynvim &&
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

    mkdir -p ~/projects &&
    git clone git@github.com:markprzepiora/ruby-binaries.git ~/projects/ruby-binaries &&
    sudo mkdir -p /opt/rubies &&
    cd ~/projects/ruby-binaries &&
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

Test colors
-----------

If you run,

    ~/dotfiles/bin/util/color-test.sh

Then the output, in both a vanilla terminal and within tmux, should look like the following:

![Color test output](bin/util/color-test.png)

If the output looks different, try running `:checkhealth` in neovim and search
for "color" in the output. It may offer suggestions.

You can also try hacking your terminfo:

    infocmp -x -A /lib/terminfo | sed -E 's/^(\t.*,)/\1Tc,RGB,/' > infocmp-hacked.txt
    tic -x infocmp-hacked.txt

If you bork your terminfo, you can delete `~/.terminfo/x/xterm-256color`
