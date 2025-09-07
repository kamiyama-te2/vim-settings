return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },

    -- キーマップ設定を追加
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      
      vim.keymap.set('v', '<leader>gs', function()
        gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})
      end, {buffer = bufnr, desc = '[gitsigns]選択行をステージング'})
      
      vim.keymap.set('v', '<leader>gr', function()
        gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})
      end, {buffer = bufnr, desc = '[gitsigns]選択行のステージングを解除'})

      -- Hunk間の移動（]c / [c）
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {buffer = bufnr, expr = true, desc = '[gitsigns]次のhunk'})

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {buffer = bufnr, expr = true, desc = '[gitsigns]前のhunk'})

      -- diff表示のトグル機能
      vim.keymap.set('n', '<leader>gd', function()
        if vim.wo.diff then
          vim.cmd('diffoff')
          vim.cmd('only')
        else
          gs.diffthis()
        end
      end, {buffer = bufnr, desc = '[gitsigns]Diff表示切り替え'})

      -- ファイル全体をステージング
      vim.keymap.set('n', '<leader>gS', gs.stage_buffer, 
        {buffer = bufnr, desc = '[gitsigns]ファイル全体をステージング'})

      -- undo stage（ステージングを戻す）
      vim.keymap.set('n', '<leader>gU', gs.undo_stage_hunk, 
        {buffer = bufnr, desc = '[gitsigns]ステージングを取り消し'})

      -- コミット関連を追加
      vim.keymap.set('n', '<leader>gc', function()
        -- ステージされた変更があるかチェック
        local staged = vim.fn.system('git diff --cached --name-only')
        if staged == '' then
          print('ステージされた変更がありません')
          return
        end
        
        local msg = vim.fn.input('Commit message: ')
        if msg ~= '' then
          vim.fn.system('git commit -m "' .. msg .. '"')
          print('コミット完了: ' .. msg)
          gs.refresh() -- Gitsignsをリフレッシュ
        end
      end, {buffer = bufnr, desc = '[gitsigns]コミット'})

    end,
  },
}
