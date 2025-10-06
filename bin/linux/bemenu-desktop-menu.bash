#!/usr/bin/env bash

#########################
# bemenu-desktop-menu
#
# Licence: GNU GPLv3
# Author: Tomasz Kapias
#
# Dependencies:
#   bemenu v0.6.23
#   bemenu-orange-wrapper
#   Nerd-Fonts
#   bash
#   GNU awk, sed, xargs
#   dex
#   setsid
#
#########################

shopt -s extglob

declare -f format_entries
declare -a bemenu_cmd desktop_path desktop_files
declare AudioVideo Audio Video Development Education Game Graphics Network \
	Office Science Settings System Utility Other
declare tmp_list tmp_entries tmp_last old_last new_last old_count new_count

# bemenu command
bemenu_cmd=(bemenu -c -i -l 20 --fixed-height -W 0.8 --fn "CaskaydiaMono Nerd Font 15")

# desktop entries directories paths
desktop_path=()

if [[ -d "$HOME/.local/share/applications" ]]; then
  desktop_path+=("$HOME/.local/share/applications")
fi

if [[ -d "/usr/local/share/applications" ]]; then
  desktop_path+=("/usr/local/share/applications")
fi

if [[ -d "/usr/share/applications" ]]; then
  desktop_path+=("/usr/share/applications")
fi

if [[ -d "/var/lib/flatpak/exports/share/applications" ]]; then
  desktop_path+=("/var/lib/flatpak/exports/share/applications")
fi

# desktop entries absolute filepaths
# shellcheck disable=SC2206
desktop_files=(${desktop_path[*]/%//*.desktop})
if [[ -z "${desktop_files[*]}" ]]; then
	echo "No Desktop entries found."
	exit 1
fi

[[ ! -d "$HOME/.cache/bemenu-desktop-menu/" ]] && /usr/bin/mkdir -p "$HOME/.cache/bemenu-desktop-menu/"
# cache storing the bemenu list generated last time
tmp_list="$HOME/.cache/bemenu-desktop-menu/list"
# cache storing filenames of unique entires
tmp_entries="$HOME/.cache/bemenu-desktop-menu/entries"
# cache storing POSIX date of the last modification and count of entries
tmp_last="$HOME/.cache/bemenu-desktop-menu/last"

# check if the cache is up-to-date
old_last=$(/usr/bin/cut -d " " -f1 2>/dev/null <"$tmp_last" || echo 0)
new_last=$(/usr/bin/stat --format='%Y' "${desktop_files[@]}" | /usr/bin/sort -n | /usr/bin/tail -1)
old_count=$(/usr/bin/cut -d " " -f2 2>/dev/null <"$tmp_last" || echo 0)
new_count=$(/usr/bin/ls "${desktop_files[@]}" | /usr/bin/wc -l)
echo -n "$new_last $new_count" >"$tmp_last"

if [[ -f "$tmp_last" ]] && [[ "$old_last" -ge "$new_last" ]] && [[ "$old_count" == "$new_count" ]]; then
	"${bemenu_cmd[@]}" --prompt "󰣆 Desktop Menu" <"$tmp_list" | /usr/bin/awk -F '[][]' '{print $2}' |
		/usr/bin/xargs -I _ /usr/bin/setsid --fork /usr/bin/dex _ >/dev/null 2>&1 &
else
	# main categories icons
	AudioVideo="🎬"
	Audio="🎧"
	Video="🎞️"
	Development="🚀"
	Education="🎓"
	Game="🎮"
	Graphics="🎨"
	Network="📡"
	Office="💼"
	Science="🧪"
	Settings="🪛"
	System="💻"
	Utility="🛠️"
	Other="❓"

	# create/clean tmp_entries
	/usr/bin/truncate --size 0 "$tmp_entries"

	format_entries() {
		local filename category name genericname
		# keep the most local version
		filename=$(/usr/bin/basename "$1")
		if /usr/bin/grep -Eq "$filename" "$tmp_entries"; then
			return
		else
			echo " $filename" >>"$tmp_entries"
		fi
		# respect NoDisplay & Hidden
		if /usr/bin/grep -Eq '^NoDisplay=true$|^Hidden=true$' "$1"; then
			return
		fi
		# assocate the first main category to an icon
		category=$(/usr/bin/printf '%s\n' "$(/usr/bin/sed -rn -e 's/;/\n/g' \
			-e '/^Categories=/{s/^Categories=(.*)$/\1 AudioVideo Audio Video Development Education Game Graphics Network Office Science Settings System Utility Other/p;q}' "$1")" |
			/usr/bin/tr ' ' '\n' | /usr/bin/sort | /usr/bin/uniq -d | /usr/bin/head -1)
		[[ -z "$category" ]] && category="Other"
		# localized names
		name=$(/usr/bin/sed -rn "/^\[Desktop Entry\]$/,/^\[/{s/^Name\[${LANGUAGE::2}\]=(.*)$/\1/p}" "$1")
		if [[ -z "$name" ]]; then
			name=$(/usr/bin/sed -rn "/^\[Desktop Entry\]$/,/^\[/{s/^Name=(.*)$/\1/p}" "$1")
		fi
		genericname=$(/usr/bin/sed -rn "/^\[Desktop Entry\]$/,/^\[/{s/^GenericName\[${LANGUAGE::2}\]=(.*)$/\1/p}" "$1")
		if [[ -z "$genericname" ]]; then
			genericname=$(/usr/bin/sed -rn "/^\[Desktop Entry\]$/,/^\[/{s/^GenericName=(.*)$/\1/p}" "$1")
		fi
		if [[ -n "$genericname" ]] && [[ ! "$genericname" == "$name" ]]; then
			genericname=" ($genericname)"
		else
			genericname=""
		fi
		padding="                                                            "
		# line for the menu
		/usr/bin/printf '%s %s%s%s [%s]\n' "${!category}" "$name" "${padding:$((${#name} + ${#genericname}))}" "$genericname" "$1"
	}

	# exports for the subshells in xargs
	export -f format_entries
	export AudioVideo Audio Video Development Education Game Graphics Network \
		Office Science Settings System Utility Other
	export tmp_entries

	# main
	/usr/bin/printf '%s\0' "${desktop_files[@]}" | /usr/bin/xargs -0 -P 8 -I {} bash -c 'format_entries "$@"' _ {} |
		/usr/bin/head -c -1 | /usr/bin/sort --ignore-case --field-separator=' ' --key=1 --key=2 | /usr/bin/tee "$tmp_list" |
		"${bemenu_cmd[@]}" --prompt "󰣆 Desktop Menu" | /usr/bin/awk -F '[][]' '{print $2}' |
		/usr/bin/xargs -I _ /usr/bin/setsid --fork /usr/bin/dex _ >/dev/null 2>&1 &
fi
