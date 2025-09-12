return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      float_opts = {
        border = "curved",
        width = 100,
        height = 25,
      },
    })
    vim.keymap.set("n", "<leader>te", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true, desc = "ターミナルをトグル" })
    vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
  end,
}
