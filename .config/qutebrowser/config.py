#-------------------------------------------------------------------------------
# Qutebrowser configuration
#-------------------------------------------------------------------------------

# Retrieve system theme
#-------------------------------------------------------------------------------

import os
import sys

sys.path.append(f"{os.environ['XDG_OPT_HOME']}/theme")
import theme

# General settings
#-------------------------------------------------------------------------------

# Loads session configuration changes from autoconfig.yml.
config.load_autoconfig(True)

c.auto_save.session = False
c.confirm_quit = [ 'downloads' ]
c.scrolling.smooth = True
c.scrolling.bar = 'always'
c.session.default_name = 'default'

# Wayland settings
#-------------------------------------------------------------------------------

c.qt.force_platform = 'wayland'

# Content settings
#-------------------------------------------------------------------------------

c.content.autoplay = False
c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.headers.do_not_track = True
c.content.javascript.enabled = False
c.content.notifications.enabled = False
c.content.user_stylesheets = [ 'stylesheet.css' ]

# File selector settings
#-------------------------------------------------------------------------------

c.fileselect.handler = 'external'
c.fileselect.single_file.command = [ 'yad', '--file', '--width', '1280', '--height', '800' ]
c.fileselect.multiple_files.command = [ 'yad', '--file', '--width', '1280', '--height', '800'  ]
c.fileselect.folder.command = [ 'yad', '--file', '--directory', '--width', '1280', '--height', '800'  ]

# Font settings
#-------------------------------------------------------------------------------

# Zoom
c.zoom.default = '125%'

# Defaults
c.fonts.default_family = [ f"{theme.font('font_mono')}" ]
c.fonts.default_size = '14pt'

# Webpages
c.fonts.web.family.fixed = f"{theme.font('font_mono')}"
c.fonts.web.family.sans_serif = f"{theme.font('font_sans')}"
c.fonts.web.family.serif = f"{theme.font('font_serif')}"
c.fonts.web.family.standard = f"{theme.font('font_sans')}"
c.fonts.web.size.minimum = 8
c.fonts.web.size.default = 18
c.fonts.web.size.default_fixed = 20

# Interface
c.fonts.contextmenu         = f"default_size {theme.font('font_sans')}"
c.fonts.debug_console       = f"default_size {theme.font('font_mono')}"
c.fonts.downloads           = f"default_size {theme.font('font_mono')}"
c.fonts.keyhint             = f"default_size {theme.font('font_mono')}"
c.fonts.prompts             = f"default_size {theme.font('font_sans')}"
c.fonts.completion.category = f"bold default_size {theme.font('font_mono')}"
c.fonts.completion.entry    = f"default_size {theme.font('font_mono')}"
c.fonts.hints               = f"bold 12pt {theme.font('font_mono')}"
c.fonts.messages.error      = f"bold 12pt  {theme.font('font_mono')}"
c.fonts.messages.info       = f"10pt {theme.font('font_mono')}"
c.fonts.messages.warning    = f"bold 12pt  {theme.font('font_mono')}"
c.fonts.statusbar           = f"default_size {theme.font('font_mono')}"
c.fonts.tabs.selected       = f"12pt {theme.font('font_sans')}"
c.fonts.tabs.unselected     = f"12pt {theme.font('font_sans')}"

# Input settings
#-------------------------------------------------------------------------------

# NOTE: Doesn't work in many cases. See: https://github.com/qutebrowser/qutebrowser/discussions/7350
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True

# URL settings
#-------------------------------------------------------------------------------

c.url.start_pages = [ 'about:blank' ]
c.url.auto_search = 'naive'
c.url.default_page = 'about:blank'
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'd': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'w': 'https://en.wikipedia.org/wiki/?search={}',
    'y': 'https://www.youtube.com/results?search_query={}',
}
c.url.yank_ignored_parameters = [ 'ref', 'utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content' ]

# Completion view component
#-------------------------------------------------------------------------------

# Appearance
c.completion.height = '40%'
c.completion.scrollbar.padding = 3
c.completion.scrollbar.width = 10

c.colors.completion.category.border.top = theme.color_hash('primary_1')
c.colors.completion.category.border.bottom = theme.color_hash('primary_1')
c.colors.completion.category.bg = theme.color_hash('primary_2')
c.colors.completion.category.fg = theme.color_hash('text_15')
c.colors.completion.even.bg = theme.color_hash('primary_1')
c.colors.completion.odd.bg = theme.color_hash('primary_1')
c.colors.completion.fg = [ theme.color_hash('text_12'), theme.color_hash('text_12'), theme.color_hash('text_12') ]

c.colors.completion.item.selected.border.bottom = theme.color_hash('primary_6')
c.colors.completion.item.selected.border.top = theme.color_hash('primary_6')
c.colors.completion.item.selected.bg = theme.color_hash('primary_6')
c.colors.completion.item.selected.fg = theme.color_hash('text_15')
c.colors.completion.item.selected.match.fg = theme.color_hash('yellow_5')
c.colors.completion.match.fg = theme.color_hash('yellow_6')
c.colors.completion.scrollbar.fg = theme.color_hash('gray_2')
c.colors.completion.scrollbar.bg = theme.color_hash('primary_1')

# Downloads component
#-------------------------------------------------------------------------------

# Appearance
c.downloads.position = 'bottom'

c.colors.downloads.bar.bg = theme.color_hash('gray_0')
c.colors.downloads.error.bg = theme.color_hash('red_1')
c.colors.downloads.error.fg = theme.color_hash('red_5')
c.colors.downloads.stop.bg = theme.color_hash('green_1')
c.colors.downloads.stop.fg = theme.color_hash('green_5')
c.colors.downloads.start.bg = theme.color_hash('blue_1')
c.colors.downloads.start.fg = theme.color_hash('blue_5')
c.colors.downloads.system.bg = 'rgb'
c.colors.downloads.system.fg = 'rgb'

# Hints component
#-------------------------------------------------------------------------------

# Behavior
c.hints.auto_follow = 'unique-match'
c.hints.auto_follow_timeout = 0
c.hints.leave_on_load = False
c.hints.mode = 'letter'
c.hints.chars = 'aghsldkfj'
c.hints.min_chars = 1
c.hints.uppercase = False

# Appearance
c.hints.border = f'1px solid {theme.color_hash("purple_2")}'
c.hints.padding = { 'top': 2, 'bottom': 0, 'left': 2, 'right': 2 }
c.hints.radius = 4

# TODO: Provide a color formatter for RGBA.
# TODO: Configure a color gradient.
# c.colors.hints.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 0.8), stop:1 rgba(255, 197, 66, 0.8))'
c.colors.hints.bg = theme.color_hash('purple_3')
c.colors.hints.fg = theme.color_hash('purple_9')
c.colors.hints.match.fg = theme.color_hash('magenta_6')

# Keyhint component
#-------------------------------------------------------------------------------

# Behavior
c.keyhint.blacklist = []
c.keyhint.delay = 500

# Appearance
c.keyhint.radius = 5

c.colors.keyhint.bg = theme.color_hash('gray_0')
c.colors.keyhint.fg = theme.color_hash('text_15')
c.colors.keyhint.suffix.fg = theme.color_hash('yellow_6')

# Messages component
#-------------------------------------------------------------------------------

# Info Test: ?
# Warning Test: Enter a search term that doesn't appear on the page.
# Error Test: `session-load` a non-existent session.

# Behavior
c.messages.timeout = 5000

# Appearance
c.colors.messages.info.border = theme.color_hash('gray_0')
c.colors.messages.info.bg = theme.color_hash('gray_0')
c.colors.messages.info.fg = theme.color_hash('text_8')
c.colors.messages.warning.border = theme.color_hash('gray_0')
c.colors.messages.warning.bg = theme.color_hash('gray_0')
c.colors.messages.warning.fg = theme.color_hash('yellow_6')
c.colors.messages.error.border = theme.color_hash('gray_0')
c.colors.messages.error.bg = theme.color_hash('gray_0')
c.colors.messages.error.fg = theme.color_hash('red_6')

# Statusbar component
#-------------------------------------------------------------------------------

# Behavior
c.statusbar.show = 'always'
c.statusbar.widgets = [ 'keypress', 'url', 'scroll', 'history', 'tabs', 'progress' ]

# Appearance
c.statusbar.padding = { 'top': 1, 'bottom': 1, 'left': 0, 'right': 0 }
c.statusbar.position = 'bottom'

c.colors.statusbar.normal.bg = theme.color_hash('gray_0')
c.colors.statusbar.normal.fg = theme.color_hash('text_12')
c.colors.statusbar.caret.bg = theme.color_hash('gray_0')
c.colors.statusbar.caret.fg = theme.color_hash('magenta_5')
c.colors.statusbar.caret.selection.bg = theme.color_hash('gray_0')
c.colors.statusbar.caret.selection.fg = theme.color_hash('cyan_6')
c.colors.statusbar.command.bg = theme.color_hash('gray_0')
c.colors.statusbar.command.fg = theme.color_hash('text_8')
c.colors.statusbar.insert.bg = theme.color_hash('gray_0')
c.colors.statusbar.insert.fg = theme.color_hash('green_5')
c.colors.statusbar.passthrough.bg = theme.color_hash('gray_0')
c.colors.statusbar.passthrough.fg = theme.color_hash('yellow_5')
c.colors.statusbar.private.bg = theme.color_hash('purple_1')
c.colors.statusbar.private.fg = theme.color_hash('text_15')
c.colors.statusbar.command.private.bg = theme.color_hash('gray_0')
c.colors.statusbar.command.private.fg = theme.color_hash('text_8')
c.colors.statusbar.progress.bg = theme.color_hash('text_15')
c.colors.statusbar.url.error.fg = theme.color_hash('red_5')
c.colors.statusbar.url.fg = theme.color_hash('text_15')
c.colors.statusbar.url.hover.fg = theme.color_hash('cyan_6')
c.colors.statusbar.url.success.http.fg = theme.color_hash('yellow_6')
c.colors.statusbar.url.success.https.fg = theme.color_hash('green_6')
c.colors.statusbar.url.warn.fg = theme.color_hash('yellow_6')

# Tabs component
#-------------------------------------------------------------------------------

# Behavior
c.tabs.last_close = 'default-page'
c.tabs.mode_on_change = 'normal'
c.tabs.new_position.related = 'next'
c.tabs.new_position.unrelated = 'next'
c.tabs.select_on_remove = 'last-used'
c.tabs.show = 'multiple'
c.tabs.tooltips = False

# Appearance
c.tabs.favicons.show = 'never'
c.tabs.indicator.width = 0
c.tabs.max_width = 240
c.tabs.padding = { 'top': 5, 'bottom': 7, 'left': 8, 'right': 8 }
c.tabs.position = 'top'
c.tabs.title.alignment = 'left'
c.tabs.title.format = '{audio}{index} ⋅ {current_title}'

c.colors.tabs.bar.bg = theme.color_hash('gray_0')
c.colors.tabs.odd.bg = theme.color_hash('gray_0')
c.colors.tabs.odd.fg = theme.color_hash('text_8')
c.colors.tabs.even.bg = theme.color_hash('gray_0')
c.colors.tabs.even.fg = theme.color_hash('text_8')
c.colors.tabs.selected.odd.bg = theme.color_hash('gray_0')
c.colors.tabs.selected.odd.fg = theme.color_hash('text_15')
c.colors.tabs.selected.even.bg = theme.color_hash('gray_0')
c.colors.tabs.selected.even.fg = theme.color_hash('text_15')

# Prompt component
#-------------------------------------------------------------------------------
c.colors.prompts.bg = theme.color_hash('primary_2')
c.colors.prompts.border = f"2px solid {theme.color_hash('primary_6')}"
c.colors.prompts.fg = theme.color_hash('text_15')
c.colors.prompts.selected.bg = theme.color_hash('primary_6')
c.colors.prompts.selected.fg = theme.color_hash('gray_15')

# Context menu component
#-------------------------------------------------------------------------------
c.colors.contextmenu.disabled.bg = theme.color_hash('primary_1')
c.colors.contextmenu.disabled.fg = theme.color_hash('text_8')
c.colors.contextmenu.menu.bg = theme.color_hash('primary_2')
c.colors.contextmenu.menu.fg = theme.color_hash('text_12')
c.colors.contextmenu.selected.bg = theme.color_hash('primary_6')
c.colors.contextmenu.selected.fg = theme.color_hash('gray_15')

# Website color settings
#-------------------------------------------------------------------------------

# Websites
c.colors.webpage.bg = theme.color_hash('secondary_0')
c.colors.webpage.preferred_color_scheme = 'dark'

# Dark mode
# see: https://github.com/qutebrowser/qutebrowser/discussions/5733
c.colors.webpage.darkmode.enabled = True

# Key bindings
#-------------------------------------------------------------------------------

# Unwanted default bindings
# TODO: Most of the default bindings should be unbound
config.unbind('<Ctrl-Shift-t>')
config.unbind('<Ctrl-Shift-w>')
config.unbind('<Ctrl-Alt-p>')
config.unbind('<Ctrl-PgDown>')
config.unbind('<Ctrl-PgUp>')
config.unbind('<Ctrl-Tab>')
config.unbind('<Ctrl-a>')
config.unbind('<Ctrl-h>')
config.unbind('<Ctrl-q>')
config.unbind('<Ctrl-p>')
config.unbind('<Ctrl-w>')
config.unbind('<Alt-m>')
config.unbind('<Back>')
config.unbind('<Forward>')
config.unbind('<F11>')
config.unbind('ad')
config.unbind('b')
config.unbind('cd')
config.unbind('co')
config.unbind('d')
config.unbind('ga')
config.unbind('gB')
config.unbind('gb')
config.unbind('gC')
config.unbind('gD')
config.unbind('gd')
config.unbind('gf')
config.unbind('gi')
config.unbind('gJ')
config.unbind('gK')
config.unbind('gm')
config.unbind('gO')
config.unbind('gu')
config.unbind('gU')
config.unbind('g0')
config.unbind('g$')
config.unbind('g^')
config.unbind('M')
config.unbind('m')
config.unbind('q')
config.unbind('Sb')
config.unbind('Sh')
config.unbind('Sq')
config.unbind('Ss')
config.unbind('sk')
config.unbind('sf')
config.unbind('sl')
config.unbind('ss')
config.unbind('th')
config.unbind('tl')
config.unbind('tCh')
config.unbind('tCH')
config.unbind('tcH')
config.unbind('tch')
config.unbind('tCu')
config.unbind('tcu')
config.unbind('tIH')
config.unbind('tIh')
config.unbind('tiH')
config.unbind('tih')
config.unbind('tIu')
config.unbind('tiu')
config.unbind('tPH')
config.unbind('tPh')
config.unbind('tpH')
config.unbind('tph')
config.unbind('tPu')
config.unbind('tpu')
config.unbind('tSH')
config.unbind('tSu')
config.unbind('tsH')
config.unbind('tsh')
config.unbind('tSh')
config.unbind('tsu')
config.unbind('yd')
config.unbind('wi')
config.unbind('wIf')
config.unbind('ZQ')
config.unbind('@')
config.unbind('.')

# General
#-- Window management
config.bind('<Space>q', 'close')

#-- Config management
config.bind('<Space>r', 'config-source ;; spawn notify-send \"Qutebrowser configuration reloaded.\"')

#-- Session management
config.bind('<Space>o', 'cmd-set-text -s :session-load')
config.bind('<Space>s', 'cmd-set-text -s :session-save -o')

#-- Tab management
config.bind('<Ctrl-q>', 'tab-close')
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Backspace>', 'tab-prev')
config.bind('H', 'tab-prev')
config.bind('L', 'tab-next')
config.bind('<Ctrl-Shift-h>', 'tab-move -')
config.bind('<Ctrl+Shift-l>', 'tab-move +')
config.bind('<Ctrl-g>', 'cmd-set-text -s :tab-give')
config.bind('<Ctrl-1>', 'tab-focus 1')
config.bind('<Ctrl-2>', 'tab-focus 2')
config.bind('<Ctrl-3>', 'tab-focus 3')
config.bind('<Ctrl-4>', 'tab-focus 4')
config.bind('<Ctrl-5>', 'tab-focus 5')
config.bind('<Ctrl-6>', 'tab-focus 6')
config.bind('<Ctrl-7>', 'tab-focus 7')
config.bind('<Ctrl-8>', 'tab-focus 8')
config.bind('<Ctrl-9>', 'tab-focus 9')

#-- Bookmark management
config.bind('<Ctrl-b>', 'spawn add-bookmark.sh {title} {url}')
config.bind('<Ctrl-Shift-b>', 'spawn select-bookmark.sh {title} {url}')

#-- Downloads
config.bind('<Space>l', 'download-clear ;; clear-messages ;; search')

#-- History navigation
config.bind('J', 'forward')
config.bind('K', 'back')

#-- Page navigation
config.bind('j', 'scroll down')
config.bind('k', 'scroll up')
config.bind('<Ctrl+a>', 'mode-enter caret ;; selection-toggle ;; move-to-end-of-document')

#-- Reader mode
config.bind('<Ctrl-r>', 'spawn --userscript readability')

#-- Format JSON
config.bind('<Ctrl-;>', 'spawn --userscript format_json.sh')

#-- Video playback
config.bind(';v', 'hint links spawn --verbose --detach mpv {hint-url} --input-ipc-server=/tmp/mpvsocket')

#-- Devtools
config.bind('<F11>', 'view-source')
config.bind('<F12>', 'devtools')

#-- Javascript
# TODO: Improve the message output by converting these commands to userscripts.
config.bind('tj', 'config-cycle -p -t -u *://*.{url:host}/* content.javascript.enabled ;; reload ;; spawn notify-send \"Toggled javascript for: {url:host}\"')
config.bind('tJ', 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload ;; spawn notify-send \"Toggled javascript for: {url:host}\"')

#-- Printing
config.bind('<Space>p', 'print')

# 'Blur' the page when exiting insert mode, removes the blinking cursor
# from the last active text element to prevent confusion.
#   see: https://github.com/qutebrowser/qutebrowser/issues/2668
config.bind('<Escape>', 'clear-keychain ;; search ;; fullscreen --leave ;; jseval -q document.activeElement.blur()')

# Insert mode
config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur()', mode='insert')

# Command mode
config.bind('<Ctrl-j>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl-k>', 'completion-item-focus --history prev', mode='command')
config.bind('<Ctrl-d>', 'completion-item-del', mode='command')

