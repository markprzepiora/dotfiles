dotfiles
========

My collection of dotfiles (for vim, tmux, git, etc.)

Ubuntu setup
------------

First make sure we have the full version of vim installed, with Ruby support.

```bash
# Make sure full vim is installed
sudo apt-get install vim vim-nox
```

Command-T should be compiled using the system Ruby, else you will likely have problems.
(You will still be able to use whichever version of Ruby you like via RVM.)

```bash
# Ensure system ruby is installed
sudo apt-get install ruby rubygems rake
```

Finally, compile Command-T.

```bash
cd ~/.vim/bundle/command-t/ruby/command-t && rake make
```

That should be all!
