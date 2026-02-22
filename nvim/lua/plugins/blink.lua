return {
  "saghen/blink.cmp",
  version = "v1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "none",

      ["<M-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<M-h>"] = { "cancel", "fallback" },
      ["<M-l>"] = { "select_and_accept", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<M-k>"] = { "select_prev", "fallback" },
      ["<M-j>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<Tab>"] = { "fallback" },
      ["<S-Tab>"] = { "accept", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    completion = {
      documentation = {
        auto_show = true,
        window = {
          scrollbar = false,
        },
      },
      menu = {
        auto_show = true,
        auto_show_delay_ms = 0,
        scrollbar = false,
      },
      ghost_text = {
        enabled = false,
        show_with_selection = true,
        show_without_selection = true,
        show_with_menu = true,
        show_without_menu = true,
      },
    },

    signature = {
      enabled = true,
      window = {
      },
    },

    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
      keymap = {
        preset = "inherit",
        ["<Tab>"] = { "accept" },
      },
    },
  },
}
