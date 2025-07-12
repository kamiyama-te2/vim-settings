-- Blink.cmp補完プラグインの設定
return {
  'saghen/blink.cmp',
  -- オプショナル: スニペットソース用のスニペットを提供
  dependencies = { 
    'rafamadriz/friendly-snippets',  -- 汎用スニペット集
    'fang2hou/blink-copilot'         -- Copilot統合
  },

  -- リリースタグを使用してビルド済みバイナリをダウンロード
  version = '*',
  -- またはソースからビルド（nightly Rustが必要）: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- Nixを使用している場合、最新のnightly Rustでビルド可能:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- キーマップ設定
    -- 'default': ビルトイン補完に似たマッピング
    -- 'super-tab': VSCode風のマッピング（Tabで受け入れ、矢印キーでナビゲート）
    -- 'enter': 'super-tab'に似ているが、Enterで受け入れ
    -- 独自のキーマップ定義については"keymap"ドキュメントを参照
    keymap = { preset = 'default' },

    -- 外観設定
    appearance = {
      -- nvim-cmpのハイライトグループをフォールバックとして設定
      -- テーマがblink.cmpをサポートしていない場合に便利
      -- 将来のリリースで削除予定
      use_nvim_cmp_as_default = true,
      -- 'Nerd Font Mono'の場合は'mono'、'Nerd Font'の場合は'normal'を設定
      -- アイコンの位置合わせのためのスペーシング調整
      nerd_font_variant = 'mono'
    },

    -- 補完ソースの設定
    -- デフォルトの有効プロバイダーリストを定義
    -- `opts_extend`により、再定義せずに他の場所で拡張可能
    sources = {
      -- デフォルトの補完ソースリスト
      default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
      -- プロバイダー別の設定
      providers = {
        -- バッファ補完の設定
        buffer = {
          score_offset = 0, -- スコアオフセットを増加（デフォルトは-3）
        },
        -- Copilot補完の設定
        copilot = {
          name = "copilot",         -- プロバイダー名
          module = "blink-copilot", -- モジュール名
          async = true,              -- 非同期処理を有効化
        },
      },
    },

    -- コマンドライン補完の設定
    cmdline = {
      enabled = false  -- コマンドライン補完を無効化
    },
  },
  -- オプションの拡張設定（sources.defaultを上書きではなく拡張）
  opts_extend = { "sources.default" }
}
