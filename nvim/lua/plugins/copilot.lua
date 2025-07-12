-- AIアシスタントプラグインの設定
return {
  -- GitHub Copilot（コード補完AI）の設定
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",         -- コマンドでの遅延ロード
    event = "InsertEnter",    -- 挿入モード開始時にロード
    config = function()
      require("copilot").setup({
        -- パネルの設定
        panel = {
          layout = {
            position = "right",  -- パネルを右側に表示
          }
        },
        -- インライン補完の設定
        suggestion = {
          enabled = false, -- 無効化（代わりにfang2hou/blink-copilotを使用）
        },
        -- 自動アタッチの制御
        should_attach = function(_, _)
          -- 常にfalseを返して自動アタッチを防ぐ
          return false
        end,

        -- Copilotのトグルキーマップ設定
        vim.keymap.set("n", "<leader>coa", function()
          local client = require("copilot.client")
          -- 現在のバッファにCopilotがアタッチされているかチェック
          if client.buf_is_attached(0) then
            -- アタッチされている場合はデタッチ
            require("copilot.command").detach()
            vim.notify("Copilot detached from buffer", vim.log.levels.INFO)
          else
            -- アタッチされていない場合は強制的にアタッチ
            require("copilot.command").attach({ force = true })
            vim.notify("Copilot attached to buffer", vim.log.levels.INFO)
          end
        end, {
          desc = "Copilot LSPのトグル",  -- キーマップの説明
        })
      })
    end,
  },
  -- Copilot Chat（対話型AIアシスタント）の設定
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- 依存関係
    dependencies = {
      { "zbirenbaum/copilot.lua" },                    -- Copilot本体
      { "nvim-lua/plenary.nvim", branch = "master" }, -- curl、ログ、非同期機能用
    },
    build = "make tiktoken",  -- tiktoken（トークナイザー）のビルド（MacOS/Linuxのみ）
    config = function()
      -- CopilotChatの初期化（デフォルト設定）
      require("CopilotChat").setup({
            show_help = "yes",
            prompts = {
              Explain = {
                  prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
                  mapping = '<leader>coe',
                  description = "コードの説明をお願いする",
              },
              Review = {
                  prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
                  mapping = '<leader>cor',
                  description = "コードのレビューをお願いする",
              },
              Fix = {
                  prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
                  mapping = '<leader>cof',
                  description = "コードの修正をお願いする",
              },
              Optimize = {
                  prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
                  mapping = '<leader>coo',
                  description = "コードの最適化をお願いする",
              },
              Docs = {
                  prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
                  mapping = '<leader>cod',
                  description = "コードのドキュメント作成をお願いする",
              },
              Tests = {
              prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
              mapping = '<leader>cot',
              description = "テストコード作成をお願いする",
              },
              FixDiagnostic = {
                  prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
                  mapping = '<leader>cod',
                  description = "コードの修正をお願いする",
                  selection = require('CopilotChat.select').diagnostics,
              },
              Commit = {
                  prompt =
                  '実装差分に対するコミットメッセージを日本語で記述してください。',
                  mapping = '<leader>coc',
                  description = "コミットメッセージの作成をお願いする",
                  selection = require('CopilotChat.select').gitdiff,
              },
              CommitStaged = {
                  prompt =
                  'ステージ済みの変更に対するコミットメッセージを日本語で記述してください。',
                  mapping = '<leader>cos',
                  description = "ステージ済みのコミットメッセージの作成をお願いする",
                  selection = function(source)
                      return require('CopilotChat.select').gitdiff(source, true)
                  end,
              },
          },
      });

      -- チャットウィンドウのトグル（ノーマル/ビジュアルモード）
      vim.keymap.set({ 'n', 'v' }, '<leader>cot', '<cmd>CopilotChatToggle<CR>',
        { desc = 'チャットウィンドウのトグル' })

      -- プロンプトテンプレートの選択
      vim.keymap.set({ 'n', 'v' }, '<leader>cop', '<cmd>CopilotChatPrompts<CR>',
        { desc = 'プロンプトテンプレートを選択' })

      -- チャットモデルの選択
      vim.keymap.set({ 'n', 'v' }, '<leader>com', '<cmd>CopilotChatModels<CR>',
        { desc = 'チャットモデルを選択' })
      -- カスタムプロンプト（複数ファイル参照用）
      vim.keymap.set({ 'n', 'v' }, '<leader>coi', function()
        local input = vim.fn.input("チャット: ")
        if input ~= "" then
          require('CopilotChat').ask(input)
        end
      end, { desc = 'カスタム指示でチャット開始' })
    end
  },
}
