-- Lua Language Serverの設定
return {
  -- Language Serverの起動コマンド
  cmd = {'lua-language-server'},
  -- 対応するファイルタイプ
  filetypes = {'lua'},
  -- プロジェクトルートの識別マーカー（Lua設定ファイルまたはGitリポジトリ）
  root_markers = {'.luarc.json', '.luarc.jsonc', '.git'},
}
