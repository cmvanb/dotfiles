#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Copyright (c) 2021 Shay Gordon
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy
# of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#-------------------------------------------------------------------------------

"""
Display colorized environment variable names and values in name order.
Run with -h or --help command line option to print usage.

Available on GiHub at https://github.com/moebius-rex/printenv.

Possible enhancements:
  * Customizable ANSI color themes
  * Generate HTML instead of plain text output
"""

__author__ = "Shay Gordon"
__email__ = "moebius.le.roi@gmail.com"

# to discover what type of platform we're running on
import platform

# colors used in ANSI escape sequences
colors = {
    'black': 0, 'red': 1, 'green': 2, 'yellow': 3, 'blue': 4, 'magenta': 5,
    'cyan': 6, 'white': 7
}

# command line arguments dictionary, populated by parse_args()
args = None

# is script running under windows os?
windows = platform.system() == 'Windows'

# default separator for multi-value variables
sep = ';' if windows else ':'

# turn off ANSI escape sequences, modified by parse_args()
off = '\033[0m'

def esc(color, bright=True):
    """Return ANSI escape sequence for supplied color and brightness."""
    return '' if windows or args.unformatted else \
        '\033[%dm' % (colors[color] + (90 if bright else 30))

def parse_args():
    """Parse command line arguments into global dictionary."""
    import argparse
    description = """description:

  Display environment variable names and values in name order.

  Features:
    * Name-sorted, colorized (Unix only) version of Unix 'env'/'printenv'
      and Windows 'set' commands.
    * Command line options provide convenient, formatted alternative to
      piping output to grep-like commands.
    * Variables containing multiple values may be printed on multiple
      lines, one per value, by providing the value separator string as
      a command line option."""

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=description)
    parser.add_argument('match', metavar='char-sequence', nargs='?',
                        help="print only those variable names/values that contain this \
            character sequence")
    parser.add_argument('-c', '--clear', action='store_true',
                        help="clear terminal before printing")
    parser.add_argument('-e', '--exact-match', action='store_true',
                        help="print only those variable names/values that exactly match the \
            character sequence provided")
    parser.add_argument('-i', '--ignore', action='store_true',
                        help="ignore case in character sequence if provided")
    parser.add_argument('-n', '--no-name-repeat', action='store_true',
                        help="when used with -s option, suppress printing of variable \
            name on all but first line of multiple value variables")
    parser.add_argument('-r', '--reset', action='store_true',
                        help="reset terminal before printing")
    parser.add_argument('-s', '--split', metavar='sep',
                        type=str, nargs='?', const=sep,
                        help="split multiple value variables by supplied 'sep' (separator, " +
                        "default '" + sep + "') string and print one value per line")
    parser.add_argument('-u', '--unformatted', action='store_true',
                        help="sort by name but disable all output formatting to produce \
            output similar to that of native operating system commands")
    parser.add_argument('-w', '--wait', action='store_true',
                        help="prompt user to exit script (useful when launching a terminal \
            window to run this command)")

    global args
    args = parser.parse_args()
    if windows or args.unformatted:
        global off
        off = ''

def clear():
    """Clear or reset terminal based on command line arguments."""
    if args.reset:
        print('\033c', end='')
    elif args.clear:
        print('\033[H\033[J', end='')

def wait():
    """Wait for user to press enter before exiting script."""
    if args.wait:
        input('\nPress return to exit')

def search():
    """
    Return a dictionary of all environment variable names and/or values
    containing the character sequence supplied on the command line, or all
    environment variables if no sequence was provided.
    """
    import os
    env = os.environ
    if args.match:
        import re
        p = re.compile(args.match, flags=re.IGNORECASE if args.ignore else 0)
        for key, value in list(env.items()):
            if args.exact_match:
                if key != args.match and value != args.match:
                    # key2 = '%s$' % key
                    # value2 = '%s$' % value
                    # print('key: ' + key2 + ', value: ' + value2)
                    # if not p.search(key2) and not p.search(value2):
                    del env[key]
            else:
                if not p.search(key) and not p.search(value):
                    del env[key]
    # return potentially empty dictionary of environment variables
    return env

def print_one(key, value, fmt):
    """
    Print one environment variable name and value(s). Output format is
    controlled by the '--split' and '--key' command line arguments.
    """

    key_color_seq = esc('white', False)

    # select value color
    if value.startswith('/'):
        # show unix path values in different color
        value_color_seq = esc('cyan', False)
    else:
        try:
            # show integer values in different color
            int(value)
            value_color_seq = esc('red', True)
        except ValueError:
            # show all other values in default color
            value_color_seq = esc('yellow', False)
    # print multivalue variables on separate lines
    if args.split and not args.unformatted:
        values = value.split(args.split)
        if len(values) > 1:
            for index, value in enumerate(values):
                if value:
                    if index > 0:
                        key_color_seq = esc('black', True)

                    key = key if not args.no_name_repeat or index == 0 else ''
                    print(fmt % (key_color_seq, key, off,
                                 value_color_seq, value, off))
            return
    # print single value variable or unseparated multivalue variable
    print(fmt % (key_color_seq, key, off,
                 value_color_seq, value, off))

def print_env():
    """
    Print colorized environment variables and values in alphabetical order.
    Variable values have different colors depending on whether they are
    integers or start with a forward slash.
    """
    env = search()
    if env:
        # generate print format string of the form:
        #     <color>[padding] key<color off> <color>value<color off>
        if args.unformatted:
            fmt = '%s%s%s=%s%s%s'
        else:
            longest_key = max(env.keys(), key=len)
            fmt = '%%s%%%ds%%s %%s%%s%%s' % len(longest_key)
        for key, value in sorted(env.items()):
            print_one(key, value, fmt)

def main():
    parse_args()

    clear()
    print_env()
    wait()

if __name__ == '__main__':
    main()

