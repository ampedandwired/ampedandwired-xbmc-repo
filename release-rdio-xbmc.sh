#!/bin/bash -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
: ${1?:"You must supply the version to release as the first param"}
$script_dir/release-addon.sh 'git@github.com:ampedandwired/rdio-xbmc.git' 'plugin.audio.rdio' "$1"
