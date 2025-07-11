-- hardtime & precognition: Vimの効率的な操作を学習するプラグイン
-- hardtime: 非効率なキー操作を制限して良い習慣を身につける
-- precognition: 次に使えるキーを表示して効率的な操作を学習
return {
  {
    "m4xshen/hardtime.nvim", -- 非効率なキー操作を制限
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" }, -- UIライブラリとユーティリティ
    opts = {
      disable_mouse = false, -- マウス使用を禁止しない
    }
  },

  {
    "tris203/precognition.nvim", -- 効率的なキー操作を表示
    config = {
      startVisible = false, -- 起動時は非表示状態
    }
  },

  -- \hキーでhardtimeのオン/オフ切り替え
  vim.keymap.set('n', '\\h', function()
    vim.cmd('Hardtime toggle')
  end, { noremap = true, silent = true, desc = 'toggle hard-time' }),

  -- \pキーでprecognitionのオン/オフ切り替え
  vim.keymap.set('n', '\\p', function()
    require("precognition").toggle()
  end, { noremap = true, silent = true, desc = 'toggle precognition' })
}
