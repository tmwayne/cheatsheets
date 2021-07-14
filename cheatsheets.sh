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

CUR_DIR=$( dirname $0 )
THIS_PROG=$( basename $0 )
USAGE="Usage: ${THIS_PROG} cheatsheet"

Help() {
  # Function to display help at command line
  echo $USAGE
  echo "Print cheatsheet to terminal with paging."
  echo
  echo "Not many options at the moment:"
  echo "  -h, --help                Print this help."
  echo
}

# Arguments --------------------------------------------------------------------

# Command-line arguments
for arg in "$@"; do
  shift
  case "$arg" in
    --help)         set -- "$@" "-h" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

OPTIND=1
while getopts ":h" opt; do
  case $opt in
    h)  Help; exit 0 ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

CS_DIR=${CHEATSHEETS_DIR:-$HOME/docs/cheatsheets/}

CS=$CS_DIR/$1.txt

# Assertions -------------------------------------------------------------------

## ASSERTIONS
########################################

if [ $# -lt 1 ]; then
  echo $USAGE
  exit 1
fi

# Main -------------------------------------------------------------------------

if [ -f "$CS" ]; then

  file_length=`wc -l $CS | cut -d' ' -f1`
  term_length=`tput lines`

  if [ $file_length -gt $term_length ]; then
    output_pager=less
  else
    output_pager=cat
  fi

  cat $CS | $output_pager
fi

