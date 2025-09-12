return {
  'mg979/vim-visual-multi',
  init = function()
    vim.api.nvim_command('let g:VM_maps = {}')
    vim.api.nvim_command("let g:VM_maps['Find Under'] = '<C-k>'")
    vim.api.nvim_command("let g:VM_maps['Find Subword Under'] = '<C-k>'")
  end
}
