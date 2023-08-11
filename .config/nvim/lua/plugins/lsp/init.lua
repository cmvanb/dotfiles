--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

local lspconfig = require('lspconfig')

-- LSP configuration
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '✘' })
sign({ name = 'DiagnosticSignWarn', text = '⚠' })
sign({ name = 'DiagnosticSignHint', text = '󰌵' })
sign({ name = 'DiagnosticSignInfo', text = 'ℹ' })

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

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = 'rounded',
    }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = 'rounded',
    }
)

-- LSP functions
local function lsp_keymaps(bufnr)
    -- TODO: Extract
    local map = function(m, lhs, rhs)
        local opts = {remap = false, silent = true, buffer = bufnr}
        vim.keymap.set(m, lhs, rhs, opts)
    end

    -- LSP actions
    map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    map('n', 'gc', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('x', 'ga', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Diagnostics
    map('n', 'gp', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map('n', 'gj', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    map('n', 'gk', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

local function lsp_attach(client, bufnr)
    local buf_command = vim.api.nvim_buf_create_user_command

    lsp_keymaps(bufnr)

    buf_command(bufnr, 'LspFormat', function()
        vim.lsp.buf.format()
    end, { desc = 'Format buffer with language server' })
end

-- Mason/LSP integration
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
    -- A list of servers to automatically install if they're not already installed.
    ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "terraformls",
        "tsserver",
        "yamlls",
    },
})

mason_lspconfig.setup_handlers({
    -- The first entry (without a key) will be the default handler and will be
    -- called for each installed server that doesn't have a dedicated handler.
    function(server_name)
        require('lspconfig')[server_name].setup({
            on_attach = lsp_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })
    end

    -- Here you can provide targeted overrides for specific servers.
    --  see: https://github.com/williamboman/mason.nvim/discussions/92
})

