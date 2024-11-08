--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local KeyMapUtils = reload('utils.keymaps')
local TableUtils = reload('utils.table')
local ThemeConfig = reload('theme.config')
local ThemeSymbols = reload('theme.symbols')

-- Diagnostics UI
--------------------------------------------------------------------------------

local sign =
    function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = '',
        })
    end

sign({ name = 'DiagnosticSignError', text = ThemeSymbols.diagnostic_signs.error })
sign({ name = 'DiagnosticSignWarn', text = ThemeSymbols.diagnostic_signs.warn })
sign({ name = 'DiagnosticSignHint', text = ThemeSymbols.diagnostic_signs.hint })
sign({ name = 'DiagnosticSignInfo', text = ThemeSymbols.diagnostic_signs.info })

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = ThemeConfig.border,
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- LSP functions
--------------------------------------------------------------------------------

local function lsp_keymaps(bufnr)
    local opts = { silent = true, buffer = bufnr }

    -- LSP actions
    KeyMapUtils.noremap(
        'gh',
        vim.lsp.buf.hover,
        TableUtils.merge(opts, { desc = 'LSP: Show hover' }))
    KeyMapUtils.noremap(
        'gs',
        vim.lsp.buf.signature_help,
        TableUtils.merge(opts, { desc = 'LSP: Show signature help' }))
    KeyMapUtils.noremap(
        'gc',
        vim.lsp.buf.rename,
        TableUtils.merge(opts, { desc = 'LSP: Rename' }))
    KeyMapUtils.noremap(
        'ga',
        vim.lsp.buf.code_action,
        TableUtils.merge(opts, { desc = 'LSP: Code action' }))
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

local mason_lspconfig = reload('mason-lspconfig')

mason_lspconfig.setup({
    -- A list of tools to automatically install if they're not already installed.
    ensure_installed = {
        'bashls',
        'clangd',
        'cssls',
        'dockerls',
        'html',
        'jsonls',
        'lua_ls',
        'pyright',
        'ts_ls',
        'yamlls',
    },
})

local base_capabilities =
    reload('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

local lsp_capabilities =
    TableUtils.merge(base_capabilities, {
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

local lsp_config = {
    on_attach = lsp_attach,
    capabilities = lsp_capabilities,
}

local lspconfig = reload('lspconfig')

-- Configure LSP handlers for each installed server. The first entry (without a
-- key) will be the default handler and will be called for each installed server
-- that doesn't have a dedicated handler.
--  see: https://github.com/williamboman/mason.nvim/discussions/92
mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup(lsp_config)
    end,

    lua_ls = function()
        local config =
            TableUtils.merge(lsp_config, {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })

        lspconfig.lua_ls.setup(config)
    end,
})
