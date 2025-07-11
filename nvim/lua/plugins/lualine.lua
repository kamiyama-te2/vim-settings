-- lualine: 軽量でカスタマイズ可能なステータスライン
-- 現在のモード、ブランチ、ファイル情報、診断情報などを表示
-- sf.nvimと連携してSalesforce組織情報も表示
return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false, -- アイコンを無効化してテキストのみ表示
      theme = 'gruvbox-material', -- gruvbox-materialカラーテーマ
      component_separators = '|', -- コンポーネント間の区切り文字
      section_separators = '', -- セクション間の区切り文字なし
    },
    sections = {
      lualine_a = { 'mode' }, -- 現在のモード（Normal、Insert等）
      lualine_b = { 'branch', 'diff', 'diagnostics' }, -- Gitブランチ、差分、診断情報
      lualine_c = { 'filename', { -- ファイル名とSalesforce組織情報
        "require'sf'.get_target_org()",
      } },
      lualine_x = { 'encoding', 'filetype' }, -- ファイルエンコーディングとタイプ
      lualine_y = { 'progress' }, -- ファイル内での位置（パーセント）
      lualine_z = { 'location' } -- 行と列の番号
    }
  },
}
