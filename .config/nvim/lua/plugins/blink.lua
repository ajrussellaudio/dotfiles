return {
  "saghen/blink.cmp",
  dependencies = {
    "Kaiser-Yang/blink-cmp-avante",
    "rafamadriz/friendly-snippets",
  },
  -- not confident that this is the right place for this
  compat = {
    "avante_commands",
    "avante_mentions",
    "avante_files",
  },
  opts = {
    snippets = { preset = "default" },
    -- ensure you have the `snippets` source (enabled by default)
    sources = {
      default = { "avante", "lsp", "path", "snippets", "buffer" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
      },
    },
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
}
