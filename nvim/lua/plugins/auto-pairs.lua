-- ultimate-autopair: 高度な自動括弧補完プラグイン
-- 括弧、引用符、HTMLタグなどの自動補完と削除を提供
-- 従来のauto-pairsより高機能で柔軟な設定が可能
return {
    {
        'altermo/ultimate-autopair.nvim',
        event = { 'InsertEnter', 'CmdlineEnter' }, -- 挿入モードとコマンドライン入力時に起動
        branch = 'v0.6', -- v0.6ブランチ使用（新バージョンには破壊的変更が含まれる可能性）
        opts = {
            -- 設定項目をここに追加
            -- 例: disable_filetype = { "TelescopePrompt", "vim" },
        },
    }
}
