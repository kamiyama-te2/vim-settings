-- markdown.nvim: Markdownファイルの見た目を美化
-- Tree-sitterを使用してMarkdownをリアルタイムで美しくレンダリング
-- 見出し、リスト、コードブロックなどにカスタム装飾を適用
return {
  'MeanderingProgrammer/markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- Tree-sitterでMarkdown解析
  config = function()
    require('render-markdown').setup({
      headings = { '🌟', '🎉 ', '⚡ ', '💡 ', '🔔 ', '🔮 ' }, -- 見出しレベル別の絵文字
      bullets = { '🔸', '🔹', '✅', '☑️' }, -- リスト項目の絵文字
      highlights = {
        heading = {
          backgrounds = {}, -- 見出しの背景色設定（空=デフォルト）
        }
      }
    })
    -- \mキーでMarkdownレンダリングのオン/オフ切り替え
    vim.keymap.set('n', '\\m', require('render-markdown').toggle, { desc = 'toggle markdown' })
  end,
}
