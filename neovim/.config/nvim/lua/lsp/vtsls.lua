return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.jsx',
  },
  settings = {
    complete_func_calls = true,
    vtsls = {
      -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
      -- enableMoveToFileCodeAction = true, -- Enable 'Move to file' code action. This action enables user to move code to existing file, but requires corresponding handling on the client side.
      autoUseWorkspaceTsdk = true, -- Automatically use workspace version of TypeScript lib on startup. By default, the bundled version is used for intelliSense.
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true, -- Execute fuzzy match of completion items on server side. Enable this will help filter out useless completion items from tsserver.
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}
