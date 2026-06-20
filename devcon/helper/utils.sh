#!/usr/bin/env bash

log() {
    echo "  → $*" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

get_os_info() {
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo "$ID" "$VERSION_ID"
	else
		echo "Error: /etc/os-release not found" >&2
		exit 1
	fi
}

version_to_int() {
	echo "$1" | awk -F. '{ printf "%d%02d", $1, $2 }'
}

in_version_range() {
	local bottomv topv version
	bottomv=$(version_to_int "$1")
	topv=$(version_to_int "$2")
	version=$(version_to_int "$3")
	[ "$version" -ge "$bottomv" ] && [ "$version" -le "$topv" ]
}

parse_installer_versions() {
	local filename
	filename="$(basename "${1%.*}")"
	IFS="-" read -r _ bottomv topv <<< "$filename"
	echo "$bottomv" "$topv"
}

source_matching_installer() {
	read -r curr_os curr_os_version <<< "$(get_os_info)"
	local matched=0

	for installer in "$curr_os"*; do
		read -r bottomv topv <<< "$(parse_installer_versions "$installer")"

		if in_version_range "$bottomv" "$topv" "$curr_os_version"; then
			. "$installer"
			matched=1
			break
		fi
	done

	if [ "$matched" -eq 0 ]; then
		echo "No matching installer found for $curr_os $curr_os_version" >&2
		exit 1
	fi
}

