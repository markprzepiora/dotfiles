# The Great Mark's-A-Big-Dummy Git Cheat Sheet

## External Links

- [Stack Overflow: How do you git show untracked files that do not exist in .gitignore](https://stackoverflow.com/questions/3538144/how-do-you-git-show-untracked-files-that-do-not-exist-in-gitignore)

## List untracked files

    git ls-files . --exclude-standard --others

## List ignored files

    git ls-files . --ignored --exclude-standard --others
