# Cheatsheets

Print cheatsheets to screen to remind of useful functions

## Install

Clone this repo and create a symlink to a directory such as `~/.local/bin`

Make sure that directory is in your system `PATH`.

Name the symlink `cs` for easy typing on the command line.

Set `CHEATSHEETS_DIR` environment variable to directory with cheatsheets.
It defaults to `~/docs/cheatsheets`.

## Usage

To view a cheatsheet simply type the name of the sheet.

    cs linux

will search the `CHEATSHEETS_DIR` for a file named linux.txt and print to screen.

If the file is too long for the screen, it will be paged using `less`.
