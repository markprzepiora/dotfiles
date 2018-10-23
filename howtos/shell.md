# The Great Mark's-A-Big-Dummy Bash Scripting Cheat Sheet


## External Links

- [Advanced Bash-Scripting Guide  Chapter 10: Manipulating Variables](http://tldp.org/LDP/abs/html/string-manipulation.html)
- [Bash string manipulation cheatsheet](https://gist.github.com/magnetikonline/90d6fe30fc247ef110a1)


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


# Bash string manipulation cheatsheet

<table>
	<tr>
		<th colspan="2">Assignment</th>
	</tr>
	<tr>
		<td>Assign <code>value</code> to <code>variable</code> if <code>variable</code> is not already set. Value will be returned.<br /><br />Couple with <code>:</code> no-op if return value is to be discarded.</td>
		<td><code>${variable="value"}</code><br /><code>: ${variable="value"}</code></td>
	</tr>
	<tr>
		<th colspan="2">Removal</th>
	</tr>
	<tr>
		<td>Delete shortest match of <code>needle</code> from front of <code>haystack</code></td>
		<td><code>${haystack#needle}</code></td>
	</tr>
	<tr>
		<td>Delete longest match of <code>needle</code> from front of <code>haystack</code></td>
		<td><code>${haystack##needle}</code></td>
	</tr>
	<tr>
		<td>Delete shortest match of <code>needle</code> from back of <code>haystack</code></td>
		<td><code>${haystack%needle}</code></td>
	</tr>
	<tr>
		<td>Delete longest match of <code>needle</code> from back of <code>haystack</code></td>
		<td><code>${haystack%%needle}</code></td>
	</tr>
	<tr>
		<th colspan="2">Replacement</th>
	</tr>
	<tr>
		<td>Replace first match of <code>needle</code> with <code>replacement</code> from <code>haystack</code></td>
		<td><code>${haystack/needle/replacement}</code></td>
	</tr>
	<tr>
		<td>Replace all matches of <code>needle</code> with <code>replacement</code> from <code>haystack</code></td>
		<td><code>${haystack//needle/replacement}</code></td>
	</tr>
	<tr>
		<td>If <code>needle</code> matches front of <code>haystack</code> replace with <code>replacement</code></td>
		<td><code>${haystack/#needle/replacement}</code></td>
	</tr>
	<tr>
		<td>If <code>needle</code> matches back of <code>haystack</code> replace with <code>replacement</code></td>
		<td><code>${haystack/%needle/replacement}</code></td>
	</tr>
	<tr>
		<th colspan="2">Substitution</th>
	</tr>
	<tr>
		<td>If <code>variable</code> not set, return <code>value</code>, else <code>variable</code></td>
		<td><code>${variable-value}</code></td>
	</tr>
	<tr>
		<td>If <code>variable</code> not set <em>or</em> empty, return <code>value</code>, else <code>variable</code></td>
		<td><code>${variable:-value}</code></td>
	</tr>
	<tr>
		<td>If <code>variable</code> set, return <code>value</code>, else null string</td>
		<td><code>${variable+value}</code></td>
	</tr>
	<tr>
		<td>If <code>variable</code> set <em>and</em> not empty, return <code>value</code>, else null string</td>
		<td><code>${variable:+value}</code></td>
	</tr>
	<tr>
		<th colspan="2">Extraction</th>
	</tr>
	<tr>
		<td>Extract <code>length</code> characters from <code>variable</code> starting at <code>position</code></td>
		<td><code>${variable:position:length}</code></td>
	</tr>
	<tr>
		<td>String length of <code>variable</code></td>
		<td><code>${#variable}</code></td>
	</tr>
</table>

## Reference
- http://tldp.org/LDP/abs/html/string-manipulation.html.
- http://tldp.org/LDP/abs/html/parameter-substitution.html.
- http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02.
