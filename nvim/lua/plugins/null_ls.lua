-- none-ls (旧null-ls): LSPに統合されたフォーマッターとリンター
-- 外部ツールをLSPクライアントとして統合してコード品質を向上
-- Salesforce Apex開発用にPrettierとPMDを設定
return {
  "nvimtools/none-ls.nvim", -- フォーマッターとリンターの設定
  event = { "BufReadPre", "BufNewFile" }, -- ファイル読み込み時に自動起動
  config = function()
    local null_ls = require("null-ls") -- none-ls (旧null-ls) を読み込み
    null_ls.setup({ -- none-ls の設定
      sources = { -- 使用するツールの設定
        -- Prettierフォーマッター（Apex用）
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "apex" }, -- Apexファイルのみ対象
          extra_args = { "--plugin=prettier-plugin-apex", "--write" }, -- Apexプラグインを使用
        }),

        -- PMD静的解析ツール（Apex用）
        null_ls.builtins.diagnostics.pmd.with({
          -- PMD v7ではラッパースクリプトが必要
          -- #!/usr/bin/env bash
          -- path/to/pmd/bin/pmd check "$@"

          filetypes = { "apex" }, -- Apexファイルのみ対象
          args = { "--format", "json", "--dir", "$ROOT", "--rulesets", "apex_ruleset.xml", "--no-cache", "--no-progress" } -- PMDの実行引数
        }),
      }
    })
  end,
}
