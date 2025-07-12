-- Nix Language Server (nil)の設定
return {
  -- 対応するファイルタイプ
  filetypes = { "nix" },
  -- プロジェクトルートの識別マーカー（Nix flakeファイルまたはGitリポジトリ）
  root_markers = {'flake.nix', '.git'},
  -- ルートディレクトリの手動設定（コメントアウトされている）
  -- root_dir = vim.fs.dirname(vim.fs.find({ "flake.nix", "shell.nix", ".git" }, { upward = true })[1]),
  -- Language Serverの設定
  settings = {
    ["nil"] = {
      -- フォーマット設定
      formatting = {
        -- alejandraフォーマッタを使用
        command = { 'alejandra' },
      },
    },
  },
}
