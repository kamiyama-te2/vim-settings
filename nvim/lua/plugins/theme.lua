return {
  {
    "masisz/ashikaga.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('ashikaga').setup({
        dim_inactive = true,
      })
      vim.cmd("colorscheme ashikaga")
    end
  }
}
