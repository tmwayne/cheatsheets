#!/bin/bash
#
# ------------------------------------------------------------------------------
# Cheatsheets
# ------------------------------------------------------------------------------
#
# Print a cheatsheet to the terminal to remind of useful commands
#
# Tyler Wayne © 2020
#

THIS_PROG=$( basename $0 )
USAGE="Usage: ${THIS_PROG} cheatsheet"
edit=false

HELP="
$USAGE
Print cheatsheet to terminal with paging.

Options:
  -e, --edit                Edit a cheatsheet
  -h, --help                Print this help.
"

# Arguments --------------------------------------------------------------------

# Command-line arguments
for arg in "$@"; do
  shift
  case "$arg" in
    --edit)         set -- "$@" "-e" ;;
    --help)         set -- "$@" "-h" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

OPTIND=1
while getopts ":eh" opt; do
  case $opt in
    e)  edit=true ;;
    # h)  Help; exit 0 ;;
    h)  echo "$HELP"; exit 0 ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

# Check if environment variable is set
cs_dir=${CHEATSHEETS_DIR:-$HOME/docs/cheatsheets}
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

