return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          end
        end,
        "select_next",
        "fallback",
      },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
}
