# The Great Mark's-A-Big-Dummy Bash Scripting Cheat Sheet


## External Links

- [Advanced Bash-Scripting Guide  Chapter 10: Manipulating Variables](http://tldp.org/LDP/abs/html/string-manipulation.html)


## Substring Removal

### Delete shortest match from front

    ${string#substring}

### Delete longest match from front

    ${string##substring}

### Delete shortest match from back

    ${string%substring}

### Delete longest match from back

    ${string%%substring}


## Filename, basename, etc.

    path_to_file=/foo/bar/baz.tar.gz

### Directory of file

    $ echo "${path_to_file%/*}"
    /foo/bar

### Basename of file

    $ echo "${path_to_file##*/}"
    baz.tar.gz

### Extension of file

By getting the basename first...

    $ basename="${path_to_file##*/}"
    $ echo "${basename#*.}"
    baz

One-liner...

    $ echo "${${path_to_file##*/}#*.}"

### Filename without extension

    $ echo "${path_to_file%%.*}"
    /foo/bar/baz

### Filename without .gz extension

    $ echo "${path_to_file%.gz}"
    /foo/bar/baz.tar
