-- デバッグとモジュール再読み込み用のユーティリティ関数

-- 元のrequire関数を保存
-- グローバルな変更の影響を受けないようにローカルに保存する
local require = require

-- plenary.nvimプラグインの再読み込み機能があるかチェック
-- plenary.nvimは開発時に便利な機能を提供するプラグイン
local ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = require  -- デフォルトは標準のrequire関数

-- plenary.nvimが利用可能な場合は、より高機能な再読み込み機能を使用
if ok then
  reloader = plenary_reload.reload_module
end

-- P関数: デバッグ用の表示関数
-- 変数の中身を見やすい形で表示し、値をそのまま返す
-- 使用例: P(my_table) でテーブルの中身を確認できる
P = function(v)
  print(vim.inspect(v))  -- vim.inspectで整形して表示
  return v               -- 元の値を返すので処理を中断しない
end

-- RELOAD関数: モジュールの再読み込み
-- Luaモジュールをキャッシュから削除して再読み込みする
-- 設定ファイルを変更した時にNeovimを再起動せずに反映できる
RELOAD = function(...)
  -- 毎回plenary.nvimの利用可否をチェック
  local ok, plenary_reload = pcall(require, "plenary.reload")
  if ok then
    reloader = plenary_reload.reload_module  -- plenary版を使用
  end
  return reloader(...)  -- 引数をそのまま渡して実行
end

-- R関数: 再読み込み + require のショートカット
-- モジュールを再読み込みしてからrequireする便利関数
-- 使用例: R("myconfig") で設定ファイルを再読み込み
R = function(name)
  RELOAD(name)      -- まず再読み込み
  return require(name)  -- 再読み込み後にrequire
end
