-- コメントの自動継続を無効化
-- 新しい行でコメントが自動的に継続されないようにする
-- TODO: Luaで直接設定する方法がわからない vim.opt.formatoptions = { c = false, r = false, o = false } は動作しない
vim.cmd([[autocmd BufEnter * set formatoptions-=cro]])

-- ヤンク（コピー）時のハイライト設定
-- テキストをヤンクした時に一時的にハイライト表示する
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()  -- ヤンクしたテキストをハイライト
  end,
  group = highlight_group,
  pattern = '*',
})

-- LSP（Language Server Protocol）設定
-- LSPがアタッチされた時の設定
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    -- \i キーでインレイヒント（型情報などの表示）をオン/オフ切り替え
    vim.keymap.set('n', '\\i', function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    end, { buffer = bufnr, desc = "インレイヒントの表示切り替え [LSP]" })
  end,
})
