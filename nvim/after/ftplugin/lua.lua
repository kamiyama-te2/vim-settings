-- Luaファイル用のキーマッピング設定
-- インサートモードでAlt+iを押すと ' = ' を挿入
vim.api.nvim_buf_set_keymap(0, 'i', '<M-i>', ' = ', { noremap = true })

-- カスタムコメントリーダーの設定
-- ネストされたバリアント（`--` と `----`）と
-- "docgen"バリアント（`---`）の両方を許可
-- Use custom comment leaders to allow both nested variants (`--` and `----`)
-- and "docgen" variant (`---`).
vim.cmd([[setlocal comments=:---,:--]])

-- Luaファイルのインデント設定
-- タブをスペースに展開
vim.opt_local.expandtab = true
-- タブキーを押した時のスペース数
vim.opt_local.softtabstop = 2
-- 自動インデント時のスペース数
vim.opt_local.shiftwidth = 2
