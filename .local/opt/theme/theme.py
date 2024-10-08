#-------------------------------------------------------------------------------
# System theme Python API
#-------------------------------------------------------------------------------

import os
import re
from color_utils import Color

# Utilities
#-------------------------------------------------------------------------------

def raise_error(message):
    raise Exception(f'[theme.py] ERROR: {message}')

def is_readable_file(path):
    return os.path.isfile(path) and os.access(path, os.R_OK)

# Parsing
#-------------------------------------------------------------------------------

def parse_error(line, column, message):
    raise_error(f'Unable to continue parsing at line {line}, {column}: {message}')

def parse_vars(filePath):

    file = open(filePath, 'r')
    lines = file.readlines()
    file.close()

    vars = {}
    line_count = 0

    for line in lines:
        key = None
        value = None
        assignment_op = False
        lookup = False

        line_count = line_count + 1

        # NOTE: Using 1-indexing both because it's more natural and to match
        # the lua implementation.
        for char_count, char in enumerate(line, start=1):
            # Space after assignment, append to value.
            # Space before assignment, keep reading.
            if char == ' ':
                if assignment_op == True:
                    if value == None:
                        value = ''
                    value = value + char
                else:
                    continue

            # Hash after assignment, char is ignored, but continue parsing value.
            # Hash before assignment, line is skipped.
            elif char == '#':
                if assignment_op == True:
                    continue
                else:
                    key = None
                    value = None
                    break

            # Quote, char is ignored, only allowed after assignment
            elif char == '\'':
                if assignment_op == True:
                    continue
                else:
                    parse_error(line_count, char_count, f'Expected character [{char}] only after assignment.')

            # Dollar, indicates variable lookup, only allowed after assignment
            elif char == '$':
                if assignment_op == True:
                    lookup = True
                    continue
                else:
                    parse_error(line_count, char_count, f'Expected character [{char}] only after assignment.')

            # Alphanumeric or underscore, append to either key or value
            elif re.search('[0-9a-zA-Z_]', char) is not None:
                if assignment_op == False:
                    if key == None:
                        key = ''
                    key = key + char
                else:
                    if value == None:
                        value = ''
                    value = value + char

            # Decimal point, append to value, only allowed after assignment
            elif char == '.':
                if assignment_op == True:
                    if value == None:
                        value = ''
                    value = value + char
                    continue
                else:
                    parse_error(line_count, char_count, f'Expected character [{char}] only after assignment.')

            # Assignment operator reached, keep reading for value
            elif char == '=':
                if assignment_op == False:
                    assignment_op = True
                    continue

            # New line char, skip to assign value
            elif char == '\n':
                break

            else:
                parse_error(line_count, char_count, f'Unknown character [{char}].')

        if key != None and value != None:
            if lookup == True:
                vars[key] = vars[value]
            else:
                vars[key] = value

    return vars

# Entry point
#-------------------------------------------------------------------------------

colors_path = os.path.expandvars('$XDG_CONFIG_HOME/theme/colors')
if is_readable_file(colors_path):
    colors = parse_vars(colors_path)
else:
    raise_error('Theme color file is not readable.')

fonts_path = os.path.expandvars('$XDG_CONFIG_HOME/theme/fonts')
if is_readable_file(fonts_path):
    fonts = parse_vars(fonts_path)

cursor_path = os.path.expandvars('$XDG_CONFIG_HOME/theme/cursor')
if is_readable_file(cursor_path):
    cursor = parse_vars(cursor_path)

# Lookup
#-------------------------------------------------------------------------------

def color_named(name):
    return colors[name]

def color_hash(name):
    return f'#{colors[name]}'

def color_zerox(name):
    return f'0x{colors[name]}'

def color_rgba(name, alpha):
    return Color(colors[name]).to_css_rgba(alpha)

def font(name):
    return fonts[name]
