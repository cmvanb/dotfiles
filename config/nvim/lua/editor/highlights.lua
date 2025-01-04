--------------------------------------------------------------------------------
-- Neovim highlights
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local HighlightsUtils = reload('utils.highlights')

-- Shortcuts
--------------------------------------------------------------------------------

local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

-- Basic configuration
--------------------------------------------------------------------------------

-- Use 24bit color if we are not in the linux terminal.
vim.opt.termguicolors = not is_linux_virtual_terminal()

-- Reset any pre-existing syntax highlighting
vim.cmd('syntax reset')

-- NVIM UI highlights
--------------------------------------------------------------------------------

-- Highlights
hi('Normal',                    { fg = 'editor_text_normal', bg = 'editor_bg' },          { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('NormalFloat',               { fg = 'editor_text_normal', bg = 'editor_bg' },          { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('NonText',                   { fg = 'gray_2' },                                        { fg = 'ansi_brwhite' })
hi('EndOfBuffer',               { fg = 'primary_4' },                                     { })
hi('LineNr',                    { fg = 'primary_6' },                                     { fg = 'ansi_blue' })
hi('Cursor',                    { fg = 'gray_0', bg = 'text_15' },                        { fg = 'ansi_black', bg = 'ansi_brwhite' })
hi('CursorLine',                { bg = 'primary_2' },                                     { bg = 'ansi_blue' })
hi('CursorLineNr',              { fg = 'primary_12', bg = 'primary_2' },                  { fg = 'ansi_brblue', bg = 'ansi_blue' })
hi('CursorLineFold',            { fg = 'gray_4', bg = 'primary_2' },                      { fg = 'ansi_brblue', bg = 'ansi_blue' })
hi('CursorLineSign',            { fg = 'ansi_brwhite', bg = 'primary_2' },                { bg = 'ansi_blue' })

hi('StatusLine',                { fg = 'text_10', bg = 'primary_1', attrs = 'bold' },     { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'bold' })
hi('StatusLineNC',              { fg = 'text_6', bg = 'primary_1' },                      { fg = 'ansi_brblack', bg = 'ansi_black' })
hi('TabLine',                   { fg = 'primary_5', bg = 'primary_1', attrs = 'bold' },   { fg = 'ansi_white', bg = 'ansi_blue' })
hi('TabLineSel',                { fg = 'primary_11', bg = 'primary_3', attrs = 'bold' },  { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'bold' })
hi('TabLineFill',               { bg = 'primary_1', attrs = 'bold' },                     { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'bold' })

hi('MsgArea',                   { fg = 'text_10', bg = 'editor_bg' },                     { fg = 'ansi_white', bg = 'ansi_black' })
hi('ErrorMsg',                  { fg = 'red_6', bg = 'red_1', attrs = 'bold' },           { fg = 'ansi_brred', bg = 'ansi_red' })
hi('WarningMsg',                { fg = 'yellow_6', bg = 'orange_3', attrs = 'bold' },     { fg = 'ansi_bryellow', bg = 'ansi_yellow' })
hi('MoreMsg',                   { fg = 'gray_15', bg = 'gray_5', attrs = 'bold' },        { fg = 'ansi_white', bg = 'ansi_brblack' })

hi('Visual',                    { fg = 'gray_0', bg = 'primary_15' },                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IncSearch',                 { fg = 'gray_0', bg = 'green_4', attrs = 'bold' },        { fg = 'ansi_black', bg = 'ansi_green' })
hi('Search',                    { fg = 'gray_0', bg = 'magenta_5', attrs = 'bold' },      { fg = 'ansi_black', bg = 'ansi_magenta' })
hi('CurSearch',                 { fg = 'gray_0', bg = 'green_4', attrs = 'bold' },        { fg = 'ansi_black', bg = 'ansi_green' })

hi('Folded',                    { bg = 'primary_1' },                                     { bg = 'ansi_blue' })
hi('FoldColumn',                { fg = 'gray_4', attrs = 'bold' },                        { fg = 'ansi_blue' })

hi('Title',                     { fg = 'text_15', attrs = 'bold' },                       { fg = 'ansi_brwhite' })
hi('PMenu',                     { fg = 'text_8', bg = 'editor_bg' },                      { fg = 'ansi_white', bg = 'ansi_black' })
hi('PMenuSel',                  { fg = 'yellow_6', bg = 'primary_5', attrs = 'bold' },    { fg = 'ansi_white', bg = 'ansi_black', attrs = 'bold' })
hi('WinSeparator',              { fg = 'primary_4' },                                     { fg = 'ansi_brblack' })
hi('MatchParen',                { fg = 'text_8', attrs = 'bold' },                        { fg = 'ansi_brwhite', attrs = 'underline' })

hi('DiffAdd',                   { fg = 'green_4', attrs = 'bold' },                       { fg = 'ansi_green' })
hi('DiffChange',                { fg = 'orange_6', attrs = 'bold' },                      { fg = 'ansi_yellow' })
hi('DiffDelete',                { fg = 'red_5', attrs = 'bold' },                         { fg = 'ansi_red' })
hi('Added',                     { fg = 'green_3', attrs = 'bold' },                       { fg = 'ansi_green' })
hi('Changed',                   { fg = 'orange_3', attrs = 'bold' },                      { fg = 'ansi_yellow' })
hi('Removed',                   { fg = 'red_3', attrs = 'bold' },                         { fg = 'ansi_red' })

hi('Directory',                 { fg = 'primary_8' },                                     { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('SpecialKey',                { fg = 'debug' },                                         { fg = 'ansi_brmagenta' })

hi('DiagnosticError',           { fg = 'red_5', attrs = 'bold' },                         { fg = 'ansi_red' })
hi('DiagnosticWarn',            { fg = 'yellow_5', attrs = 'bold' },                      { fg = 'ansi_bryellow' })
hi('DiagnosticInfo',            { fg = 'text_10', attrs = 'bold' },                       { fg = 'ansi_white' })
hi('DiagnosticHint',            { fg = 'orange_7', attrs = 'bold' },                      { fg = 'ansi_yellow' })
hi('DiagnosticUnderlineError',  { sp = 'red_5', attrs = 'undercurl' },                    { fg = 'ansi_red' })
hi('DiagnosticUnderlineWarn',   { sp = 'yellow_5', attrs = 'undercurl' },                 { fg = 'ansi_yellow' })
hi('DiagnosticUnderlineInfo',   { sp = 'text_10', attrs = 'undercurl' },                  { fg = 'ansi_white' })
hi('DiagnosticUnderlineHint',   { sp = 'orange_7', attrs = 'undercurl' },                 { fg = 'ansi_magenta' })
hi('SpellBad',                  { sp = 'red_5', attrs = 'undercurl' },                    { fg = 'ansi_red', attrs = 'underline' })

-- Links
ln('CursorColumn',         'CursorLine')
ln('FloatBorder',          'WinSeparator')
ln('Question',             'MoreMsg')
ln('ModeMsg',              'MoreMsg')
ln('Error',                'ErrorMsg')
ln('healthSuccess',        'MoreMsg')
ln('VertSplit',            'WinSeparator')
ln('Whitespace',           'NonText')
ln('DiagnosticSignError',  'DiagnosticError')
ln('DiagnosticSignWarn',   'DiagnosticWarn')
ln('DiagnosticSignInfo',   'DiagnosticInfo')
ln('DiagnosticSignHint',   'DiagnosticHint')

-- Custom UI highlights
--------------------------------------------------------------------------------

-- Highlights
hi('CMenuNormal',         { fg = 'debug', bg = 'primary_1' },                    { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('CMenuSelection',      { fg = 'text_15', bg = 'primary_8', attrs = 'bold' },  { fg = 'ansi_brwhite', bg = 'ansi_black', attrs = 'bold' })
hi('CMenuItem',           { fg = 'text_10' },                                    { fg = 'ansi_brblue' })
hi('CMenuItemMatch',      { fg = 'yellow_6', attrs = 'bold' },                   { fg = 'ansi_bryellow' })

hi('FloatMenuNormal',     { fg = 'text_10', bg = 'editor_bg' },                  { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('FloatMenuSelection',  { fg = 'text_15', bg = 'primary_7', attrs = 'bold' },  { fg = 'ansi_brwhite', bg = 'ansi_black', attrs = 'bold' })
hi('FloatMenuItemMatch',  { fg = 'magenta_5', attrs = 'bold' },                   { fg = 'ansi_cyan', bg = 'ansi_blue' })

-- Links
ln('QuickFixLine',  'FloatMenuSelection')

-- Plugin highlights
--------------------------------------------------------------------------------

-- Highlights
hi('CopilotSuggestion',        { fg = 'text_6' },                                        { fg = 'ansi_brblack' })
hi('GitSignsAddCul',           { fg = 'green_3', bg = 'primary_2', attrs = 'bold' },     { fg = 'ansi_green', bg = 'ansi_blue' })
hi('GitSignsChangeCul',        { fg = 'orange_3', bg = 'primary_2', attrs = 'bold' },    { fg = 'ansi_yellow', bg = 'ansi_blue' })
hi('GitSignsDeleteCul',        { fg = 'red_3', bg = 'primary_2', attrs = 'bold' },       { fg = 'ansi_red', bg = 'ansi_blue' })
hi('IblIndent',                { fg = 'gray_1' },                                        { fg = 'ansi_brblack' })
hi('IblWhitespace',            { fg = 'gray_1' },                                        { fg = 'ansi_brblack' })
hi('IblScope',                 { fg = 'gray_4' },                                        { fg = 'ansi_brblack' })
hi('IlluminatedWordRead',      { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IlluminatedWordText',      { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IlluminatedWordWrite',     { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('LeapMatch',                { fg = 'debug', attrs = 'bold' },                         { fg = 'ansi_magenta' })
hi('LeapLabelPrimary',         { fg = 'gray_0', bg = 'primary_15', attrs = 'bold' },     { fg = 'ansi_magenta' })
hi('LeapLabelSecondary',       { fg = 'primary_2', bg = 'primary_11', attrs = 'bold' },  { fg = 'ansi_brmagenta' })
hi('LeapLabelSelected',        { fg = 'debug', attrs = 'bold' },                         { fg = 'ansi_brmagenta' })
hi('LualineDiffAdd',           { fg = 'green_4', bg = 'primary_4', attrs = 'bold' },     { fg = 'ansi_green' })
hi('LualineDiffChange',        { fg = 'orange_6', bg = 'primary_4', attrs = 'bold' },    { fg = 'ansi_yellow' })
hi('LualineDiffDelete',        { fg = 'red_5', bg = 'primary_4', attrs = 'bold' },       { fg = 'ansi_red' })
hi('LualineDiagError',         { fg = 'red_6', bg = 'primary_4', attrs = 'bold' },       { fg = 'ansi_red' })
hi('LualineDiagWarn',          { fg = 'yellow_5', bg = 'primary_4', attrs = 'bold' },    { fg = 'ansi_yellow' })
hi('LualineDiagInfo',          { fg = 'text_10', bg = 'primary_4', attrs = 'bold' },     { fg = 'ansi_white' })
hi('LualineDiagHint',          { fg = 'orange_7', bg = 'primary_4', attrs = 'bold' },    { fg = 'ansi_magenta' })

-- Links
ln('CmpMenuBackground',       'CMenuNormal')
ln('CmpMenuSelect',           'CMenuSelection')
ln('CmpItemAbbr',             'CMenuItem')
ln('CmpItemAbbrMatch',        'CMenuItemMatch')
ln('CmpItemKind',             'Type')
ln('TelescopeNormal',         'FloatMenuNormal')
ln('TelescopeBorder',         'WinSeparator')
ln('TelescopeTitle',          'Title')
ln('TelescopePromptCounter',  'TelescopeTitle')
ln('TelescopePromptPrefix',   'TelescopeTitle')
ln('TelescopeMatching',       'FloatMenuItemMatch')
ln('TelescopeSelection',      'FloatMenuSelection')
ln('TelescopePreviewNormal',  'Normal')

-- Syntax highlights
--------------------------------------------------------------------------------

-- Highlights
hi('Identifier',  { fg = 'secondary_9' },                                                 { fg = 'ansi_cyan' })
hi('Statement',   { fg = 'green_4', attrs = 'bold' },                                     { fg = 'ansi_brgreen', attrs = 'bold' })
hi('Comment',     { fg = 'text_6', attrs = 'italic' },                                    { fg = 'ansi_brblack' })
hi('Type',        { fg = 'secondary_12' },                                                { fg = 'ansi_brcyan', attrs = 'bold' })
hi('Constant',    { fg = 'magenta_5' },                                                   { fg = 'ansi_brmagenta' })
hi('Special',     { fg = 'yellow_5', attrs = 'bold' },                                    { fg = 'ansi_yellow' })
hi('Underlined',  { fg = 'primary_15', attrs = 'underline' },                             { fg = 'ansi_blue', attrs = 'underline' })
hi('Delimiter',   { fg = 'green_4' },                                                     { fg = 'ansi_green' })
hi('String',      { fg = 'orange_6' },                                                    { fg = 'ansi_yellow' })
hi('Keyword',     { fg = 'green_4', attrs = 'bold' },                                     { fg = 'ansi_brgreen', attrs = 'bold' })
hi('Function',    { fg = 'secondary_15', attrs = 'bold' },                                { fg = 'ansi_brcyan', attrs = 'bold' })
hi('Number',      { fg = 'red_6' },                                                       { fg = 'ansi_brred' })
hi('Boolean',     { fg = 'red_5' },                                                       { fg = 'ansi_red' })
hi('Ignore',      { fg = 'text_3', attrs = 'bold' },                                      { fg = 'ansi_brblack' })
hi('Todo',        { fg = 'secondary_15', bg = 'secondary_5', attrs = 'bold,nocombine' },  { fg = 'ansi_brcyan', bg = 'ansi_cyan', attrs = 'bold' })

-- Links
ln('vimCommentTitle',          'Comment')
ln('vimOption',                'Identifier')
ln('Operator',                 'Keyword')
ln('PreProc',                  'Special')
ln('@attribute',               'Special')
ln('@constant.builtin',        'Constant')
ln('@constant.builtin.python', 'Constant')
ln('@constructor',             'Function')
ln('@function.builtin',        'Special')
ln('@function.call',           'Function')
ln('@punctuation.delimiter',   'Delimiter')
ln('@markup.list',             'Delimiter')
ln('@string.documentation',    'Comment')
ln('@string.special',          'Special')
ln('@string.regex',            'Special')
ln('@tag.attribute',           'Type')
ln('@tag.delimiter',           'Delimiter')
ln('@text.literal',            'String')
ln('@type.builtin',            'Special')
ln('@type.qualifier',          'Keyword')
ln('@variable',                'Identifier')
ln('@variable.builtin',        'Identifier')
ln('@lsp.mod.defaultLibrary',  'Special')

-- Special snowflakes
--------------------------------------------------------------------------------

-- Highlight notes everywhere, just like todos.
vim.api.nvim_create_augroup('HighlightNotes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    group = 'HighlightNotes',
    callback = function()
        vim.fn.matchadd('Todo', 'TODO:\\|NOTE:\\|see:')
    end,
})
