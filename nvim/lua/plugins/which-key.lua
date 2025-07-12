return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "バッファローカルキーマップ (which-key)",
    },
  },
}
