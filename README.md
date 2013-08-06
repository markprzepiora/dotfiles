dotfiles
========

My collection of dotfiles (for vim, tmux, git, etc.)


Included stuff
--------------

The supplied `.zshenv` will load [rbenv](https://github.com/sstephenson/rbenv)
or [rvm](https://github.com/wayneeseguin/rvm) if they exist. This is done in
*all* shells, even non-interactive ones. If you want these package managers to
be loaded only in interactive shells, you can move the appropriate lines into
`.zshrc` instead.


Customization
-------------

Add **interactive-mode customizations** (such as aliases, color stuff, etc.) to
`~/.zshrc_private`. This will be loaded after the contents of the supplied
`.zshrc` file.

Add **environment-related customizations** (such as PATH customization) to
`~/.zshenv_private`. This will be loaded after the contents of the supplied
`.zshenv` file.


Ubuntu setup
------------

Make sure git is installed (sudo apt-get install git) and simply run,

```bash
curl -L dotfiles.przepiora.ca/ubuntu.bash | bash
```

This will clone the repository and set up your environment. 

If you are planning to use tmux, you will probably have to edit `.tmux.conf`
and remove the OSX-specific fixes at the top.


OSX setup
---------

No fancy script for this, but if you check out the repo into `~/dotfiles` and
run `link-all.sh`, this should create the proper symlinks. Then you just need
to compile Command-T and set your default shell to zsh.

If you are using tmux together with rbenv, you will need to make a small patch
to the `/etc/zshenv` provided with OSX. New versions of rbenv will add the
shims directory to your path **only once**, even if it is not the first entry
in your path. When you start a tmux session, it runs a new login shell, causing
the dreaded `/usr/libexec/path_helper` utility to be run a second time,
reordering your path. This is a problem.

**tl;dr**: to fix it, make this change:

```diff
--- /etc/zshenv.orig
+++ /etc/zshenv
@@ -1,4 +1,5 @@
 # system-wide environment settings for zsh(1)
 if [ -x /usr/libexec/path_helper ]; then
+ PATH=""
  eval `/usr/libexec/path_helper -s`
 fi
```
