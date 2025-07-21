return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash"},
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter"},
      { "ｓ", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash"},
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash"},
      { "S", mode = { "x", "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search"},
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search"},
    },
  }
}
