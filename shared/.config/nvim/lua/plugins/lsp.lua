return {
  {
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            local fzf_lua = require 'fzf-lua'

            map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
            map('grr', fzf_lua.lsp_references, '[G]oto [R]eferences')
            map('gri', fzf_lua.lsp_implementations, '[G]oto [I]mplementation')
            map('grd', fzf_lua.lsp_definitions, '[G]oto [D]efinition')
            map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            map('grO', fzf_lua.lsp_document_symbols, 'Open Document Symbols')
            map('grW', fzf_lua.lsp_live_workspace_symbols, 'Open Workspace Symbols')
            map('grt', fzf_lua.lsp_typedefs, '[G]oto [T]ype Definition')
            require('which-key').add { 'gr', group = 'Code Actions' }

            -- Highlight references to word under cursor
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })
              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })
      end,
    },
    {
      'mason-org/mason.nvim',
      opts = {},
    },
    {
      'mason-org/mason-lspconfig.nvim',
      opts = {},
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          -- Web dev
          'emmet_language_server',
          'eslint',
          'prettier',
          'prettierd',
          'tailwindcss',
          'vtsls', -- TypeScript

          -- Other langs
          'gofumpt',
          'goimports',
          'gopls',
          'terraform',
          'terraform-ls',
          'tflint',

          -- Docs
          'markdown-toc',
          'marksman',

          -- Neovim config
          'lua_ls',
          'stylua',
          'tree-sitter-cli',

          -- Scripting
          'bashls',
        },
      },
    },
  },
}
