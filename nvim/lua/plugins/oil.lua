return {
  {
    'stevearc/oil.nvim',

    opts = {
      default_file_explorer = true,
      columns = {
        "icon"
      },

      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },

      keymap = {
        ["<CR>"] = { "actions.select", desc = "ファイル/ディレクトリを開く" },
        ["<C-s>"] = { "actions.select", opts = { vertival = true }, desc = "垂直分割で開く" },
        ["<C-v>"] = { "actions.select", opts = { horizontal = true }, desc = "水平分割で開く" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "新しいタブで開く" },
        ["<C-p>"] = { "actions.preview", desc = "プレビューを表示" },
        ["<C-c>"] = { "actions.close", desc = "エクスプローラーを閉じる" },
        ["<Esc>"] = { "actions.close", desc = "エクスプローラーを閉じる" },
        ["<C-r>"] = { "actions.refresh", desc = "ディレクトリを更新" },
        ["-"] = { "actions.parent", desc = "親ディレクトリに移動" },
        ["cd"] = { "actions.cd", mode = "n", desc = "現在のディレクトリに移動" },
        ["gh"] = { "actions.toggle_hidden", mode = "n", desc = "隠しファイルの表示/非表示を切り替え" },
        ["g\\"] = { "actions.toggle_trash", mode = "n", desc = "ゴミ箱表示の切り替え" },
      },

      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
        natural_order = true,
        case_insensitive = true,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      float = {
        padding = 2,
        max_width = 0.9,
        max_height = 0.9,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
      }
    },

    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "ファイルエクスプローラーを開く" })
    end,
  }
}
