-- nvim-treesitter: 高性能な構文解析とコードハイライト
-- Tree-sitterパーサーでより正確な構文解析を提供
-- textobjectsとcontextプラグインで高度なコード操作が可能
return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require("treesitter-context").setup({
          enable = false,
          max_lines = 4,
          trim_scope = 'inner',
        })
        vim.keymap.set('n', '\\c', require 'treesitter-context'.toggle,
          { noremap = true, silent = true, desc = 'treesitter-context' })
      end
    },
  },
  build = ':TSUpdate', -- インストール時にTree-sitterパーサーを自動更新
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "apex", "bash", "haskell", "nix", "rust", "soql", "sosl", "lua", "vim", "vimdoc", "markdown" }, -- 自動インストールする言語パーサー
      auto_install = true, -- 新しいファイルタイプのパーサーを自動インストール

      highlight = {
        enable = true, -- Tree-sitterベースのハイライト有効化
        additional_vim_regex_highlighting = false, -- 従来のVim正規表現ハイライトを無効化
      },
      debug = true,

      textobjects = { -- コード要素をテキストオブジェクトとして操作
        select = { -- 構文要素の選択機能
          enable = true,
          lookahead = true, -- カーソルより先の要素も検索対象に含める

          keymaps = { -- テキストオブジェクト選択のキーマッピング
            ["l="] = { query = "@assignment.lhs", desc = "ts: 代入左辺" },
            ["r="] = { query = "@assignment.rhs", desc = "ts: 代入右辺" },
            -- ["aa"] = { query = "@parameter.outer", desc = "ts: 外側のパラメータ" },
            -- ["ia"] = { query = "@parameter.inner", desc = "ts: 内側のパラメータ" },
            -- ["am"] = { query = "@function.outer", desc = "ts: 外側の関数" },
            -- ["im"] = { query = "@function.inner", desc = "ts: 内側の関数" },
            -- ["ai"] = { query = "@conditional.outer", desc = "ts: 外側の条件文" },
            -- ["ii"] = { query = "@conditional.inner", desc = "ts: 内側の条件文" },

            -- ["a="] = { query = "@assignment.outer", desc = "ts: 外側の代入" },
            -- ["i="] = { query = "@assignment.inner", desc = "ts: 内側の代入" },
            -- ["a:"] = { query = "@property.outer", desc = "ts: オブジェクトプロパティの外側部分" },
            -- ["i:"] = { query = "@property.inner", desc = "ts: オブジェクトプロパティの内側部分" },
            -- ["l:"] = { query = "@property.lhs", desc = "ts: オブジェクトプロパティの左側部分" },
            -- ["r:"] = { query = "@property.rhs", desc = "ts: オブジェクトプロパティの右側部分" },
            -- ["al"] = { query = "@loop.outer", desc = "ts: 外側のループ" },
            -- ["il"] = { query = "@loop.inner", desc = "ts: 内側のループ" },
            -- ["af"] = { query = "@call.outer", desc = "ts: 外側の関数呼び出し" },
            -- ["if"] = { query = "@call.inner", desc = "ts: 内側の関数呼び出し" },
            -- ["ac"] = { query = "@class.outer", desc = "ts: 外側のクラス" },
            -- ["ic"] = { query = "@class.inner", desc = "ts: 内側のクラス" },
          },
        },

        move = { -- 構文要素間の移動機能
          enable = true,
          set_jumps = true, -- ジャンプリストに移動履歴を記録
          goto_next_start = { -- 次の構文要素の開始位置に移動
            ["]m"] = { query = "@function.outer", desc = "ts: 次の関数開始" },
            ["]a"] = { query = "@parameter.inner", desc = "ts: 次の引数" },
            -- ["]c"] = { query = "@class.outer", desc = "ts: 次のクラス開始" },
            -- ["]i"] = { query = "@conditional.outer", desc = "ts: 次の条件文開始" },
            -- ["]l"] = { query = "@loop.outer", desc = "ts: 次のループ開始" },
            -- ["]s"] = { query = "@scope", query_group = "locals", desc = "ts: 次のスコープ" },
            -- ["]z"] = { query = "@fold", query_group = "folds", desc = "ts: 次のフォールド" },
          },
          goto_next_end = { -- 次の構文要素の終了位置に移動
            ["]M"] = { query = "@function.outer", desc = "ts: 次の関数終了" },
            -- ["]C"] = { query = "@class.outer", desc = "ts: 次のクラス終了" },
            -- ["]I"] = { query = "@conditional.outer", desc = "ts: 次の条件文終了" },
            -- ["]L"] = { query = "@loop.outer", desc = "ts: 次のループ終了" },
          },
          goto_previous_start = { -- 前の構文要素の開始位置に移動
            ["[m"] = { query = "@function.outer", desc = "ts: 前の関数開始" },
            ["[a"] = { query = "@parameter.inner", desc = "ts: 前の引数" },
            -- ["[c"] = { query = "@class.outer", desc = "ts: 前のクラス開始" },
            -- ["[i"] = { query = "@conditional.outer", desc = "ts: 前の条件文開始" },
            -- ["[l"] = { query = "@loop.outer", desc = "ts: 前のループ開始" },
          },
          goto_previous_end = { -- 前の構文要素の終了位置に移動
            ["[M"] = { query = "@function.outer", desc = "ts: 前の関数終了" },
            -- ["[C"] = { query = "@class.outer", desc = "ts: 前のクラス終了" },
            -- ["[I"] = { query = "@conditional.outer", desc = "ts: 前の条件文終了" },
            -- ["[L"] = { query = "@loop.outer", desc = "ts: 前のループ終了" },
          },
        },

        swap = { -- 構文要素の位置交換機能
          enable = true,
          swap_next = { -- 次の要素と位置を交換
            ["<leader>na"] = { query = "@parameter.inner", desc = "ts: 次のパラメータと交換" },
            ["<leader>nm"] = { query = "@function.outer", desc = "ts: 次の関数と交換" },
            -- ["<leader>n:"] = { query = "@property.outer", desc = "ts: 次のプロパティと交換" },
          },
          swap_previous = { -- 前の要素と位置を交換
            ["<leader>pa"] = { query = "@parameter.inner", desc = "ts: 前のパラメータと交換" },
            ["<leader>pm"] = { query = "@function.outer", desc = "ts: 前の関数と交換" },
            -- ["<leader>p:"] = { query = "@property.outer", desc = "ts: 前のプロパティと交換" },
          },
        },
      },
    })
  end,
}
