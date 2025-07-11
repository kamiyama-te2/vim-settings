-- nvim-tree: ファイルエクスプローラー
-- サイドバーでファイルとディレクトリを表示・操作
-- プロジェクトのファイル構造を視覚的に管理
return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
        {mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする"}, -- Ctrl+n でファイルツリーを開閉
        {mode = "n", "<C-m>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカス"}, -- Ctrl+m でファイルツリーにフォーカス
    },
    opts = {}, -- デフォルト設定を使用
  },
}
