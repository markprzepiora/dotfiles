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

### Chocolatey

Open PowerShell as an administrator.

Then run:

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Then install:

    choco install -y googlechrome 7zip vlc foobar2000 sublimetext4 steam everything dropbox adobe-creative-cloud autohotkey geforce-experience signal cpu-z geekbench OpenHardwareMonitor sysinternals wiztree zoom discord

### Manual downloads

Chocolatey does not have definitions for a few things.

- [1Password 8](https://downloads.1password.com/win/1PasswordSetup-latest.exe)
- [Twitch Studio](https://spotlight.twitchsvc.net/installer/windows/TwitchStudioSetup-network.exe)
- [Spotify](https://download.scdn.co/SpotifySetup.exe)

### WSL Setup

First install Ubuntu:

    wsl --install -d Ubuntu

Once you get into a bash terminal, install packages we'll need:

    sudo apt-get update --yes
    sudo apt-get upgrade --yes
    sudo apt-get install --yes -qq parallel wget build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev software-properties-common
    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt-get update --yes
    sudo apt-get install --yes -qq libssl1.0-dev
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
    sudo apt-get update --yes
    sudo apt-get install postgresql-9.6

Install Ruby binaries:

    mkdir -p ~/projects
    git clone git@github.com:markprzepiora/ruby-binaries.git ~/projects/ruby-binaries
    sudo mkdir /opt/rubies
    cd ~/projects/ruby-binaries
    bin/install-rubies-remote

Install dotfiles:

    curl https://raw.githubusercontent.com/markprzepiora/dotfiles/master/setup.sh | bash
