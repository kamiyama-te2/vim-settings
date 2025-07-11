-- sf.nvim: Salesforce開発支援プラグイン
-- Salesforce組織との連携、Apexクラスの編集、SOQLクエリの実行などを提供
-- 開発ブランチ（dev）を使用してより多くの機能を利用可能
return {
  'xixiaofinland/sf.nvim',
  branch = 'main',

  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- 構文解析とハイライト
    "ibhagwan/fzf-lua", -- ファジーファインダー機能
  },

  config = function()
    require('sf').setup()
    local Sf = require('sf')

    vim.keymap.set('n', '<leader>ss', Sf.set_target_org, { desc = "対象組織を設定" })
    vim.keymap.set('n', '<leader>sf', Sf.fetch_org_list, { desc = "組織リストを取得/更新" })
    vim.keymap.set('n', '<leader><leader>', Sf.toggle_term, { desc = "ターミナルの切り替え" })
    vim.keymap.set('n', '<leader>sp', Sf.save_and_push, { desc = "現在のファイルをプッシュ" })
    vim.keymap.set('n', '<leader>sr', Sf.retrieve, { desc = "現在のファイルを取得" })
    vim.keymap.set('n', '<leader>ta', Sf.run_all_tests_in_this_file, { desc = "ファイル内の全Apexテストを実行" })
    vim.keymap.set('n', '<leader>tt', Sf.run_current_test, { desc = "カーソル下のテストを実行" })
    vim.keymap.set('n', '<leader>tr', Sf.repeat_last_tests, { desc = "最後のテストを再実行" })
    vim.keymap.set('n', '<leader>to', Sf.open_test_select, { desc = "テスト選択バッファを開く" })
    vim.keymap.set('n', '<leader>ct', Sf.create_ctags, { desc = "ctagsファイルを作成" })
    vim.keymap.set('v', '<leader>sq', Sf.run_highlighted_soql, { desc = "選択したテキストをSOQLとしてターミナルで実行" })
    vim.keymap.set('n', '\\s', Sf.toggle_sign, { desc = "行カバレッジ表示アイコンの表示/非表示" })
    vim.keymap.set('n', ']v', Sf.uncovered_jump_forward, { desc = "次の未カバーコードへジャンプ" })
    vim.keymap.set('n', '[v', Sf.uncovered_jump_backward, { desc = "前の未カバーコードへジャンプ" })
    vim.keymap.set('n', '<leader>dd', Sf.diff_in_target_org, { desc = "現在のファイルと対象組織のファイルの差分を表示" })
    vim.keymap.set('n', '<leader>oh', Sf.org_open, { desc = "組織をブラウザで開く" })
    vim.keymap.set('n', '<leader>e', '<CMD>e ~/.config/nvim/lua/plugins/sf.lua<CR>',
      { desc = 'nvimのsfプラグイン設定ファイルを開く' })
  end
}
