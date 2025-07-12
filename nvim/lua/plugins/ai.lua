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
        vim.keymap.set("n", "<leader>at", function()
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
      require("CopilotChat").setup({});

      -- チャットウィンドウのトグル（ノーマル/ビジュアルモード）
      vim.keymap.set({ 'n', 'v' }, '<leader>ao', '<cmd>CopilotChatToggle<CR>',
        { desc = 'チャットウィンドウのトグル' })

      -- プロンプトテンプレートの選択
      vim.keymap.set({ 'n', 'v' }, '<leader>ap', '<cmd>CopilotChatPrompts<CR>',
        { desc = 'プロンプトテンプレートを選択' })

      -- チャットモデルの選択
      vim.keymap.set({ 'n', 'v' }, '<leader>am', '<cmd>CopilotChatModels<CR>',
        { desc = 'チャットモデルを選択' })
    end
  },
}
