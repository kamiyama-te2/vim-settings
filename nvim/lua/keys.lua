-- ============================================================================
-- キーマッピング設定
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.o.timeoutlen = 400

-- ============================================================================
-- 基本キーマッピング
-- ============================================================================

-- 行の入れ替え（Alt + j/k）
map('n', '<A-j>', ':m .+1<CR>==', { desc = '行を下に移動' })
map('n', '<A-k>', ':m .-2<CR>==', { desc = '行を上に移動' })

-- インサートモードでの行移動
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = '行を下に移動（挿入モード）' })
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = '行を上に移動（挿入モード）' })

-- ビジュアルモードでの行移動
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = '選択行を下に移動' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = '選択行を上に移動' })

-- 削除でレジスタに格納しない
map('n', 'x', '"_x', { desc = '削除でレジスタに格納しない' })

-- ノーマルモード中でもエンターキーで改行挿入
map('n', '<CR>', 'i<CR>', { desc = 'エンターキーで改行挿入' })

-- j, kによる移動を折り返されたテキストでも自然に振る舞うように変更
map('n', 'j', 'gj', { desc = '下に移動（折り返し対応）' })
map('n', 'k', 'gk', { desc = '上に移動（折り返し対応）' })

-- Ctrl + hjklでウィンドウ移動
map('n', '<C-h>', '<C-w>h', { desc = 'ウィンドウ左に移動' })
map('n', '<C-j>', '<C-w>j', { desc = 'ウィンドウ下に移動' })
map('n', '<C-k>', '<C-w>k', { desc = 'ウィンドウ上に移動' })
map('n', '<C-l>', '<C-w>l', { desc = 'ウィンドウ右に移動' })

-- {}で空行を検索
map('n', '{', '?^\\s*$<CR>', { desc = '上の空行に移動' })
map('n', '}', '/^\\s*$<CR>', { desc = '下の空行に移動' })

-- Escapeキー（挿入モードから抜ける）
map('i', '<Leader>j', '<Esc>', { desc = 'インサートモードから抜ける' })

-- 全選択
map('n', '<Leader>a', 'myggVG$', { desc = '全選択（ノーマルモード）' })
map('i', '<Leader>a', '<Esc>myggVG$', { desc = '全選択（インサートモードから）' })

--  相対行番号使用時の2つのジャンプ問題を一度に解決
-- 参考: https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- 参考: https://www.reddit.com/r/neovim/comments/1b4xefk/comment/kt5n8xl/
-- 大きな移動（2行以上）の場合はマークを設定してから移動、1行移動は折り返し行を考慮
map('n', 'k', [[(v:count > 1 ? "m'" . v:count : "g") . 'k']], { expr = true })
map('n', 'j', [[(v:count > 1 ? "m'" . v:count : "g") . 'j']], { expr = true })

-- 半画面スクロール後にカーソルを画面中央に配置
map("n", "<C-d>", "<C-d>zz")  -- 下スクロール
map("n", "<C-u>", "<C-u>zz")  -- 上スクロール

-- 検索結果を画面中央に表示
map("n", "n", "nzzzv")  -- 次の検索結果
map("n", "N", "Nzzzv")  -- 前の検索結果

-- ============================================================================
-- インデント操作
-- ============================================================================

-- Tabでインデントを増やす
map('n', '<Tab>', '>>', { desc = 'インデントを増やす' })
map('v', '<Tab>', '>gv', { desc = 'インデントを増やす（選択維持）' })

-- Shift+Tabでインデントを減らす
map('n', '<S-Tab>', '<<', { desc = 'インデントを減らす' })
map('v', '<S-Tab>', '<gv', { desc = 'インデントを減らす（選択維持）' })

-- ============================================================================
-- LSP（Language Server Protocol）関連のキーマッピング
-- ============================================================================

-- コードフォーマット実行（2.5秒でタイムアウト）
map('n', '<leader>fl', function() vim.lsp.buf.format({ timeout_ms = 2500 }) end,
  { noremap = true, silent = true, desc = 'ファイルをフォーマット' })

-- 診断情報をフローティングウィンドウで表示
map('n', 'D', vim.diagnostic.open_float, { noremap = true, silent = true, desc = '診断情報表示' })

-- コードアクション（修正候補）を表示
map('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'コードアクション' })

-- 変数・関数名のリネーム
map('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true, desc = 'リネーム' })

-- ============================================================================
-- ファイル関連のキーマッピング
-- ============================================================================

-- ファイル操作
map('n', '<Leader>w', ':w<CR>', { desc = 'ファイル保存' })
map('n', '<Leader>q', ':q<CR>', { desc = 'ファイル終了' })

-- Ctrl + sで保存、Ctrl + qで終了
map('i', '<C-s>', '<Esc>:w<CR>', { desc = 'ファイル保存' })
map('i', '<C-q>', '<Esc>:q<CR>', { desc = 'ファイル終了' })

-- 現在のディレクトリに新しいファイルを作成
-- <leader>fnで現在のファイルと同じディレクトリにファイル作成コマンドを実行
map('n', '<leader>fn', function() return ':e ' .. vim.fn.expand '%:p:h' .. '/' end,
  { expr = true, desc = '新しいファイルを作成' })

-- ファイル名をクリップボードにコピー
map('n', '<leader>cfn', function()
  local file_name = vim.fn.expand("%:t")  -- ファイル名のみ取得
  vim.fn.setreg('*', file_name)           -- システムクリップボードに保存
  vim.notify(string.format('"%s" copied.', file_name), vim.log.levels.INFO)
end, { desc = 'ファイル名をコピー' })

-- ファイルのフルパスをクリップボードにコピー
map('n', '<leader>cfN', function()
  local file_name = vim.fn.expand("%:p")  -- フルパス取得
  vim.fn.setreg('*', file_name)           -- システムクリップボードに保存
  vim.notify(string.format('"%s" copied.', file_name), vim.log.levels.INFO)
end, { desc = 'ファイルのフルパスをコピー' })

-- ============================================================================
-- 日本語入力用キーマッピング
-- ============================================================================

-- 日本語入力がオンのままでも使えるコマンド
map('n', 'あ', 'a', { desc = '追加モード（日本語入力対応）' })
map('n', 'い', 'i', { desc = '挿入モード（日本語入力対応）' })
map('n', 'う', 'u', { desc = 'アンドゥ（日本語入力対応）' })
map('n', 'お', 'o', { desc = '新しい行を開く（日本語入力対応）' })
map('n', 'っd', 'dd', { desc = '行削除（日本語入力対応）' })
map('n', 'っy', 'yy', { desc = '行コピー（日本語入力対応）' })

-- 全角スペース + 全角文字でのマッピング
map('i', '　ｊ', '<Esc>', { desc = 'インサートモードから抜ける（全角）' })
map('n', '　ｗ', ':w<CR>', { desc = 'ファイル保存（全角）' })
map('n', '　　', '<C-w>w', { desc = 'ウィンドウ移動（全角）' })
map('n', '　ｒ', ':source ~/.vimrc<CR>', { desc = 'vimrc読み込み（全角）' })
map('n', '　ｖｒ', ':new ~/.vimrc<CR>', { desc = 'vimrc編集（全角）' })
map('i', '　ａ', '<Esc>myggVG$', { desc = '全選択（インサートモードから、全角）' })
map('n', '　ａ', 'myggVG$', { desc = '全選択（ノーマルモード、全角）' })
map('n', '　ｑ', ':q<CR>', { desc = 'ファイル終了（全角）' })

-- ============================================================================
-- 日本語検索用キーマッピング
-- ============================================================================

-- スペース + f(F,t,T) で digraph を入力で、日本語の検索ができるようにする
map('n', '<space>f', 'f<C-k>', { desc = '日本語文字検索（前方）' })
map('n', '<space>F', 'F<C-k>', { desc = '日本語文字検索（後方）' })
map('n', '<space>t', 't<C-k>', { desc = '日本語文字まで移動（前方）' })
map('n', '<space>T', 'T<C-k>', { desc = '日本語文字まで移動（後方）' })

-- ============================================================================
-- その他のキーマッピング
-- ============================================================================

-- 検索ハイライトをクリア
map('n', '<Esc><Esc>', ':nohlsearch<CR>', { desc = '検索ハイライトをクリア' })

-- 文字列置換のショートカット
map('v', '<leader>r', 'y:%s/<C-r>"//gc<Left><Left><Left>', { desc = "選択した文字列を置換" })
map('n', '<leader>rw', ':%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>', { desc = "カーソル下の単語を置換" })

-- 行末の区切り文字（; と ,）を切り替える機能
local toggle = function(character)
  local api = vim.api
  local delimiters = { ',', ';' }
  local line = api.nvim_get_current_line()
  local last_char = line:sub(-1)  -- 行の最後の文字を取得

  if last_char == character then
    -- 同じ文字の場合は削除
    return api.nvim_set_current_line(line:sub(1, #line - 1))
  elseif vim.tbl_contains(delimiters, last_char) then
    -- 他の区切り文字の場合は置換
    return api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
  else
    -- 区切り文字がない場合は追加
    return api.nvim_set_current_line(line .. character)
  end
end
map('n', '<leader>,', function() toggle(',') end, { noremap = true, silent = true, desc = 'カンマ切り替え' })
map('n', '<leader>;', function() toggle(';') end, { noremap = true, silent = true, desc = 'セミコロン切り替え' })

