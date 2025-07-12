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

    vim.keymap.set('n', '<leader>sft', Sf.set_target_org, { desc = "[SF]対象組織を設定" })
    vim.keymap.set('n', '<leader>sfol', Sf.fetch_org_list, { desc = "[SF]組織リストを取得/更新" })
    vim.keymap.set('n', '<leader><leader>', Sf.toggle_term, { desc = "[SF]ターミナルの切り替え" })
    vim.keymap.set('n', '<leader>sfp', Sf.save_and_push, { desc = "[SF]現在のファイルをプッシュ" })
    vim.keymap.set('n', '<leader>sfr', Sf.retrieve, { desc = "[SF]現在のファイルを取得" })
    vim.keymap.set('n', '<leader>sfta', Sf.run_all_tests_in_this_file, { desc = "[SF]ファイル内の全Apexテストを実行" })
    vim.keymap.set('n', '<leader>sftt', Sf.run_current_test, { desc = "[SF]カーソル下のテストを実行" })
    vim.keymap.set('n', '<leader>sftr', Sf.repeat_last_tests, { desc = "[SF]最後のテストを再実行" })
    vim.keymap.set('n', '<leader>sfto', Sf.open_test_select, { desc = "[SF]テスト選択バッファを開く" })
    vim.keymap.set('n', '<leader>sfct', Sf.create_ctags, { desc = "[SF]ctagsファイルを作成" })
    vim.keymap.set('v', '<leader>sfsq', Sf.run_highlighted_soql, { desc = "[SF]選択したテキストをSOQLとしてターミナルで実行" })
    vim.keymap.set('n', '\\s', Sf.toggle_sign, { desc = "[SF]行カバレッジ表示アイコンの表示/非表示" })
    vim.keymap.set('n', ']v', Sf.uncovered_jump_forward, { desc = "[SF]次の未カバーコードへジャンプ" })
    vim.keymap.set('n', '[v', Sf.uncovered_jump_backward, { desc = "[SF]前の未カバーコードへジャンプ" })
    vim.keymap.set('n', '<leader>sfdd', Sf.diff_in_target_org, { desc = "[SF]現在のファイルと対象組織のファイルの差分を表示" })
    vim.keymap.set('n', '<leader>sfop', Sf.org_open, { desc = "[SF]組織をブラウザで開く" })
    vim.keymap.set('n', '<leader>sfse', '<CMD>e ~/.config/nvim/lua/plugins/sf.lua<CR>',
      { desc = '[SF]nvimのSFプラグイン設定ファイルを開く' })
  end
}
