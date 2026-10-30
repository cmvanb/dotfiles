--------------------------------------------------------------------------------
-- Generate the justpager carbon theme template from Neovim's highlights
--
-- Run through generate-theme.sh, inside Neovim with the user configuration.
-- Every capture resolves the way Neovim resolves it: `@capture.language`, then
-- shorter names, then links. Groups from the highlights registry keep their
-- palette names, so the template follows `theme switch`.
--------------------------------------------------------------------------------

local output = assert(vim.env.JUSTPAGER_THEME_OUTPUT, 'JUSTPAGER_THEME_OUTPUT is unset')
local registry = assert(_G._highlights_registry, 'the highlights registry is missing').groups
local theme = require('theme.system')

local attributes = { 'bold', 'italic', 'underline', 'strikethrough', 'nocombine' }
local failures = {}

local function fail(message)
    table.insert(failures, message)
end

-- A style is { fg = { palette = name } | { hex = '#rrggbb' }, bg = ..., bold = true, ... }.
local function registry_style(group, gui)
    local style = {}
    for _, key in ipairs({ 'fg', 'bg' }) do
        local name = gui[key]
        if name and name ~= 'NONE' then
            style[key] = { palette = name }
        end
    end
    for attribute in (gui.attrs or 'NONE'):gmatch('[^,]+') do
        if vim.tbl_contains(attributes, attribute) then
            style[attribute] = true
        elseif attribute ~= 'NONE' and attribute ~= 'none' then
            fail(group .. ' uses unsupported attribute ' .. attribute)
        end
    end
    return style
end

local function builtin_style(definition)
    local style = {}
    for _, key in ipairs({ 'fg', 'bg' }) do
        if definition[key] then
            style[key] = { hex = string.format('#%06x', definition[key]) }
        end
    end
    for _, attribute in ipairs(attributes) do
        if definition[attribute] then
            style[attribute] = true
        end
    end
    return style
end

local function resolve(group, depth)
    depth = depth or 0
    if depth > 32 then
        fail('link cycle at ' .. group)
        return {}
    end
    local entry = registry[group]
    if entry then
        if entry.target then
            return resolve(entry.target, depth + 1)
        end
        return registry_style(group, entry.gui or {})
    end
    local definition = vim.api.nvim_get_hl(0, { name = group, link = true })
    if definition.link then
        return resolve(definition.link, depth + 1)
    end
    if next(definition) then
        return builtin_style(definition)
    end
    local parent = group:match('^(.*)%.[^.]+$')
    return parent and resolve(parent, depth + 1) or {}
end

local function hex(color)
    return color.hex or theme.color_hash(color.palette):lower()
end

-- The template must reproduce what Neovim paints with the active palette.
local function verify(group, style)
    local actual = vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name(group), link = false })
    local expected = {}
    for _, key in ipairs({ 'fg', 'bg' }) do
        expected[key] = style[key] and hex(style[key]) or nil
        local painted = actual[key] and string.format('#%06x', actual[key]) or nil
        if expected[key] ~= painted then
            fail(string.format('%s %s: template %s, Neovim %s', group, key, tostring(expected[key]), tostring(painted)))
        end
    end
    for _, attribute in ipairs(attributes) do
        if (style[attribute] or false) ~= (actual[attribute] or false) then
            fail(group .. ' ' .. attribute .. ' differs from Neovim')
        end
    end
end

local function render(style)
    local parts = {}
    for _, key in ipairs({ 'fg', 'bg' }) do
        local color = style[key]
        if color then
            local value = color.palette and ("${color_hash('" .. color.palette .. "')}") or color.hex
            table.insert(parts, string.format('%s = "%s"', key, value))
        end
    end
    for _, attribute in ipairs(attributes) do
        if style[attribute] then
            table.insert(parts, attribute .. ' = true')
        end
    end
    if #parts == 0 then
        return '{}'
    end
    return '{ ' .. table.concat(parts, ', ') .. ' }'
end

local listing = vim.system({ 'justpager', '--list-captures' }, { text = true }):wait()
if listing.code ~= 0 then
    error('justpager --list-captures failed: ' .. (listing.stderr or ''))
end

local entries = {}
for line in listing.stdout:gmatch('[^\n]+') do
    local language, capture = line:match('^(%S+)\t(%S+)$')
    assert(language, 'unexpected capture line: ' .. line)
    local generic = '@' .. capture
    local specific = generic .. '.' .. language
    local generic_style = resolve(generic)
    local specific_style = resolve(specific)
    verify(specific, specific_style)
    entries[capture] = render(generic_style)
    if render(specific_style) ~= entries[capture] then
        entries[capture .. '.' .. language] = render(specific_style)
    end
end

local normal = resolve('Normal')
verify('Normal', normal)

local keys = vim.tbl_keys(entries)
table.sort(keys)

local lines = {
    '## Generated by generate-theme.sh from the Neovim highlights. Do not edit.',
    '[normal]',
}
for _, key in ipairs({ 'fg', 'bg' }) do
    if normal[key] then
        table.insert(lines, render({ [key] = normal[key] }):match('^{ (.*) }$'))
    end
end
table.insert(lines, '')
table.insert(lines, '[syntax]')
for _, key in ipairs(keys) do
    table.insert(lines, string.format('"%s" = %s', key, entries[key]))
end

if #failures > 0 then
    io.stderr:write(table.concat(failures, '\n') .. '\n')
    vim.cmd('cquit 1')
end

local file = assert(io.open(output, 'w'))
file:write(table.concat(lines, '\n') .. '\n')
file:close()
