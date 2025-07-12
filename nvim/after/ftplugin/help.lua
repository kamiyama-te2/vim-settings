-- ヘルプページを仮想的に開く（:hコマンド用）
-- open :h pages virtually
-- ヘルプウィンドウを右側に垂直分割で表示
vim.cmd([[autocmd BufWinEnter <buffer> wincmd L]])
