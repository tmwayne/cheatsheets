#!/bin/bash
#
# ------------------------------------------------------------------------------
# cheatsheets.sh
# ------------------------------------------------------------------------------
#
# Copyright © 2022 Tyler Wayne
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

THIS_PROG=$( basename $0 )
USAGE="Usage: ${THIS_PROG} [-e] cheatsheet"

HELP="\
$USAGE
It's not cheating if you don't get caught..

Options:
  -e, --edit                Edit a cheatsheet
  -h, --help                Print this help
  -V, --version             Print version info"

VERSION="\
Cheatsheets v1.0.0
Copyright © 2022 Tyler Wayne
Licensed under the Apache License, Version 2.0

Written by Tyler Wayne."

# Arguments --------------------------------------------------------------------

# Default args
edit=false

# Environment variables
cs_dir=${CHEATSHEETS_DIR:-$HOME/docs/cheatsheets}

# Command-line arguments
for arg in "$@"; do
  shift
  case "$arg" in
    --edit)         set -- "$@" "-e" ;;
    --help)         set -- "$@" "-h" ;;
    --version)      set -- "$@" "-V" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

OPTIND=1
while getopts ":ehV" opt; do
  case $opt in
    e)  edit=true ;;
    h)  echo "$HELP"; exit 0 ;;
    V)  echo "$VERSION"; exit 0 ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

cs=$cs_dir/$1.txt

# Assertions -------------------------------------------------------------------

if [ $# -lt 1 ]; then
  echo $USAGE
  exit 1
fi

# Main -------------------------------------------------------------------------

# TODO: if file doesn't exist, copy a cheatsheet template and open that.
if $edit; then
  $EDITOR $cs

elif [ -f "$cs" ]; then

  # On OSX, leading white space is added to wc output. Use awk to remove it.
  file_length=`wc -l $cs | awk '{$1=$1}1' | cut -d' ' -f1`
  term_length=`tput lines`

  if [ $file_length -gt $term_length ]; then
    output_pager=less
  else
    output_pager=cat
  fi

  $output_pager $cs
fi

