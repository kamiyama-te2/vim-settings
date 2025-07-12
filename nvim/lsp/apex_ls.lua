-- Apex Language Serverの設定
return {
  -- Language Serverの起動コマンド
  cmd = {
    "java",
    "-jar",
    vim.fn.expand("$HOME/apex-jorje-lsp.jar"),
  },
  -- 対応するファイルタイプ
  filetypes = { "apex" },
  -- プロジェクトルートの識別マーカー
  root_markers = { 'sfdx-project.json', '.git' },
  -- Language Serverの設定
  settings = {
    apex = {
      -- セマンティックエラーの無効化
      apex_enable_semantic_errors = false,
      -- 補完統計の無効化
      apex_enable_completion_statistics = false,
    },
  },
}
