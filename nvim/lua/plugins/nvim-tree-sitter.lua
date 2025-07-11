-- nvim-treesitter: 高性能な構文解析とコードハイライト
-- Tree-sitterパーサーでより正確な構文解析を提供
-- textobjectsとcontextプラグインで高度なコード操作が可能
return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects', -- 構文要素をテキストオブジェクトとして操作
    'nvim-treesitter/nvim-treesitter-context' -- 現在のコンテキストを上部に表示
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

      textobjects = { -- コード要素をテキストオブジェクトとして操作
        select = { -- 構文要素の選択機能
          enable = true,
          lookahead = true, -- カーソルより先の要素も検索対象に含める

          keymaps = { -- テキストオブジェクト選択のキーマッピング
            ["l="] = { query = "@assignment.lhs", desc = "ts: left assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "ts: right assignment" },
            -- ["aa"] = { query = "@parameter.outer", desc = "ts: outer parameter" },
            -- ["ia"] = { query = "@parameter.inner", desc = "ts: inner parameter" },
            -- ["am"] = { query = "@function.outer", desc = "ts: outer function" },
            -- ["im"] = { query = "@function.inner", desc = "ts: inner function" },
            -- ["ai"] = { query = "@conditional.outer", desc = "ts: outer conditional" },
            -- ["ii"] = { query = "@conditional.inner", desc = "ts: inner conditional" },

            -- ["a="] = { query = "@assignment.outer", desc = "ts: outer assignment" },
            -- ["i="] = { query = "@assignment.inner", desc = "ts: inner ssignment" },
            -- ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
            -- ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
            -- ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
            -- ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
            -- ["al"] = { query = "@loop.outer", desc = "ts: outer loop" },
            -- ["il"] = { query = "@loop.inner", desc = "ts: inner loop" },
            -- ["af"] = { query = "@call.outer", desc = "ts: outer function-call" },
            -- ["if"] = { query = "@call.inner", desc = "ts: inner function-call" },
            -- ["ac"] = { query = "@class.outer", desc = "ts: outer class" },
            -- ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
          },
        },

        move = { -- 構文要素間の移動機能
          enable = true,
          set_jumps = true, -- ジャンプリストに移動履歴を記録
          goto_next_start = { -- 次の構文要素の開始位置に移動
            ["]m"] = { query = "@function.outer", desc = "ts: next def method/function start" },
            ["]a"] = { query = "@parameter.inner", desc = "ts: next def method/function start" },
            -- ["]c"] = { query = "@class.outer", desc = "ts: next class start" },
            -- ["]i"] = { query = "@conditional.outer", desc = "ts: next conditional start" },
            -- ["]l"] = { query = "@loop.outer", desc = "next loop start" },
            -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = { -- 次の構文要素の終了位置に移動
            ["]M"] = { query = "@function.outer", desc = "ts: next def method/function end" },
            -- ["]C"] = { query = "@class.outer", desc = "ts: next class end" },
            -- ["]I"] = { query = "@conditional.outer", desc = "ts: next conditional end" },
            -- ["]L"] = { query = "@loop.outer", desc = "ts: next loop end" },
          },
          goto_previous_start = { -- 前の構文要素の開始位置に移動
            ["[m"] = { query = "@function.outer", desc = "ts: prev def method/function start" },
            ["[a"] = { query = "@parameter.inner", desc = "ts: next def method/function start" },
            -- ["[c"] = { query = "@class.outer", desc = "ts: prev class start" },
            -- ["[i"] = { query = "@conditional.outer", desc = "ts: prev conditional start" },
            -- ["[l"] = { query = "@loop.outer", desc = "ts: prev loop start" },
          },
          goto_previous_end = { -- 前の構文要素の終了位置に移動
            ["[M"] = { query = "@function.outer", desc = "ts: prev def method/function end" },
            -- ["[C"] = { query = "@class.outer", desc = "ts: prev class end" },
            -- ["[I"] = { query = "@conditional.outer", desc = "ts: prev conditional end" },
            -- ["[L"] = { query = "@loop.outer", desc = "ts: prev loop end" },
          },
        },

        swap = { -- 構文要素の位置交換機能
          enable = true,
          swap_next = { -- 次の要素と位置を交換
            ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
            ["<leader>nm"] = "@function.outer",  -- swap function with next
            -- ["<leader>n:"] = "@property.outer",    -- swap object property with next
          },
          swap_previous = { -- 前の要素と位置を交換
            ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
            ["<leader>pm"] = "@function.outer",  -- swap function with previous
            -- ["<leader>p:"] = "@property.outer",  -- swap object property with prev
          },
        },
      },
    })
  end,
}
