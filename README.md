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

If you are planning to use tmux, you will probably have to edit `.tmux.conf`
and remove the OSX-specific fixes at the top if you aren't using OSX.


Customization
-------------

Add **interactive-mode customizations** (such as aliases, color stuff, etc.) to
`~/.zshrc_private`. This will be loaded after the contents of the supplied
`.zshrc` file.

Add **environment-related customizations** (such as PATH customization) to
`~/.zshenv_private`. This will be loaded after the contents of the supplied
`.zshenv` file.

