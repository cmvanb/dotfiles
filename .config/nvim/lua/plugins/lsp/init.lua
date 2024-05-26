--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local KeyMapUtils = reload('utils.keymaps')
local TableUtils = reload('utils.table')

-- Diagnostics UI
--------------------------------------------------------------------------------

local sign =
    function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

if not is_linux_virtual_terminal() then
    sign({ name = 'DiagnosticSignError', text = '󰅜 ' })
    sign({ name = 'DiagnosticSignWarn',  text = ' ' })
    sign({ name = 'DiagnosticSignHint',  text = '󰌵 ' })
    sign({ name = 'DiagnosticSignInfo',  text = 'ℹ ' })
else
    sign({ name = 'DiagnosticSignError', text = 'x ' })
    sign({ name = 'DiagnosticSignWarn',  text = '! ' })
    sign({ name = 'DiagnosticSignHint',  text = '? ' })
    sign({ name = 'DiagnosticSignInfo',  text = 'i ' })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- LSP UI
--------------------------------------------------------------------------------

vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(
        vim.lsp.handlers.hover,
        {
            border = 'rounded',
        })

vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = 'rounded',
        })

-- LSP functions
--------------------------------------------------------------------------------

local function lsp_keymaps(bufnr)
    local nnoremap, xnoremap =
        KeyMapUtils.nnoremap,
        KeyMapUtils.xnoremap

    local opts = { silent = true, buffer = bufnr }

    -- LSP actions
    nnoremap('gh', vim.lsp.buf.hover, opts)
    nnoremap('gs', vim.lsp.buf.signature_help, opts)
    nnoremap('gc', vim.lsp.buf.rename, opts)
    nnoremap('ga', vim.lsp.buf.code_action, opts)
end

local function lsp_attach(_, bufnr)
    local buf_command = vim.api.nvim_buf_create_user_command

    lsp_keymaps(bufnr)

    buf_command(bufnr, 'LspFormat', function()
        vim.lsp.buf.format()
    end, { desc = 'Format buffer with language server' })
end

-- Mason/LSP integration
--------------------------------------------------------------------------------

local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
    -- A list of servers to automatically install if they're not already installed.
    ensure_installed = {
        'bashls',
        'clangd',
        'cssls',
        'dockerls',
        'html',
        'jsonls',
        'lua_ls',
        'pyright',
        'terraformls',
        'tsserver',
        'yamlls',
    },
})

local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities =
    TableUtils.merge(cmp_nvim_lsp.default_capabilities(), {
        textDocument = {
            -- Enable snippets with LuaSnip.
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
            -- Enable folding with UFO.
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    })

local default_config = {
    on_attach = lsp_attach,
    capabilities = capabilities,
}

local lua_ls_config =
    TableUtils.merge(default_config, {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    })

local lspconfig = require('lspconfig')

-- Configure LSP handlers for each installed server. The first entry (without a
-- key) will be the default handler and will be called for each installed server
-- that doesn't have a dedicated handler.
--  see: https://github.com/williamboman/mason.nvim/discussions/92
mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup(default_config)
    end,

    lua_ls = function()
        lspconfig.lua_ls.setup(lua_ls_config)
    end,
})
