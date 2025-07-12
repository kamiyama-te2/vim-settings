-- LazyDevプラグインの設定（Neovim Lua APIの補完とドキュメント）
return {
  -- LazyDev本体の設定
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Luaファイルのみでロード
    opts = {
      library = {
        -- 設定の詳細はドキュメントを参照
        -- `vim.uv`が見つかったときにluvitタイプをロード
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- Blink.cmp用のオプショナル補完ソース（require文とモジュールアノテーション用）
  {
    "saghen/blink.cmp",
    opts = {
      -- 補完ソースの設定
      sources = {
        -- LazyDevを補完プロバイダーに追加
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          -- LazyDevプロバイダーの設定
          lazydev = {
            name = "LazyDev",                     -- プロバイダー名
            module = "lazydev.integrations.blink", -- 統合モジュール
            -- LazyDev補完を最優先にする（`:h blink.cmp`参照）
            score_offset = 100,
          },
        },
      },
    },
  }
  -- 注意: neodev.nvimはアンインストールまたは無効化すること
  -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
