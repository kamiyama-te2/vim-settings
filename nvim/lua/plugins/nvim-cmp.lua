-- nvim-cmp: 高性能な自動補完エンジン
-- LSP、スニペット、バッファ、ファイルパスなどの多様なソースから補完候補を提供
-- カスタマイズ可能なキーマッピングと補完メニューを提供
return {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter", -- 挿入モード時に自動読み込み
  dependencies = {
    'hrsh7th/cmp-buffer', -- バッファ内のテキストから補完
    'hrsh7th/cmp-path', -- ファイルパスの補完
    'L3MON4D3/LuaSnip', -- スニペットエンジン
    'saadparwaiz1/cmp_luasnip', -- LuaSnipとnvim-cmpの統合
    'rafamadriz/friendly-snippets', -- 汎用的なスニペットコレクション
    'hrsh7th/cmp-nvim-lsp', -- LSPからの補完候補
    "onsails/lspkind.nvim", -- VS Code風のアイコン表示
  },
  config = function()
    local cmp = require 'cmp' -- nvim-cmpを読み込み
    local luasnip = require 'luasnip' -- LuaSnipエンジンを読み込み
    local lspkind = require 'lspkind' -- アイコン表示を読み込み
    require('luasnip.loaders.from_vscode').lazy_load() -- VS Codeスタイルのスニペットを遅延読み込み
    cmp.setup({ -- nvim-cmpのメイン設定
      completion = {
        completeopt = "menu,menuone,preview,noselect", -- 補完メニューの表示設定
      },
      snippet = { -- nvim-cmpとスニペットエンジンの連携設定
        expand = function(args)
          luasnip.lsp_expand(args.body) -- LuaSnipでスニペットを展開
        end,
      },
      mapping = cmp.mapping.preset.insert { -- キーマッピング設定
        ['<C-n>'] = cmp.mapping.select_next_item(), -- 次の候補を選択
        ['<C-p>'] = cmp.mapping.select_prev_item(), -- 前の候補を選択
        ['<C-y>'] = cmp.mapping.confirm { select = true }, -- 選択した候補を確定
        ['<C-Space>'] = cmp.mapping.complete {}, -- 手動で補完メニューを表示
        ['<C-l>'] = cmp.mapping(function() -- スニペットの次のジャンプポイントへ移動
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function() -- スニペットの前のジャンプポイントへ移動
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- ['<CR>'] = cmp.mapping.confirm {
        --   behavior = cmp.ConfirmBehavior.Replace,
        --   select = true,
        -- },
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_locally_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
      },
      sources = cmp.config.sources({ -- 補完ソースの優先度設定
        { name = "nvim_lsp" }, -- LSPからの補完（最高優先度）
        { name = "luasnip" }, -- スニペット補完
        { name = "buffer" },  -- 現在のバッファ内のテキスト
        { name = "path" },    -- ファイルシステムパス
      }),
      -- VS Code風のアイコン表示設定
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50, -- 補完メニューの最大幅
          ellipsis_char = "...", -- 省略文字
        }),
      },
    })
  end
}
