-- harpoon: 高速ファイル/バッファ移動プラグイン
-- よく使うファイルをマークして素早く移動できる
-- The Primeagen開発、harpoon2はより高速で安定したバージョン
return {
  'ThePrimeagen/harpoon',
  branch = "harpoon2", -- 最新版のharpoon2を使用
  dependencies = { "nvim-lua/plenary.nvim" }, -- Lua関数ライブラリ
  config = function()
    local name = "[H] " -- キーマッピング説明用のプレフィックス
    local harpoon = require("harpoon")
    harpoon:setup()

    -- UIが作成されたときに垂直分割で開く機能を追加
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })
      end,
    })

    -- 基本的なキーマッピング
    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = name .. "add" }) -- 現在のファイルを追加
    vim.keymap.set("n", "<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = name .. "list" }) -- harpoonメニューを開く

    -- 1-6番のファイルに直接移動するキーマッピング
    for index = 1, 6 do
      vim.keymap.set("n", "<leader>h" .. index, function()
        harpoon:list():select(index)
      end, { desc = name .. "move to #" .. index })
    end
  end
}
