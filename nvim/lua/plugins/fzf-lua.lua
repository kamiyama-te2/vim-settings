-- fzf-lua: 高性能なファジーファインダー
-- ファイル、バッファ、Git、LSPなどの様々なソースから素早く検索・選択できる
-- ripgrepやfzfのパワーを活用した検索機能を提供
return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- fzf-luaの基本設定
            require("fzf-lua").setup({
                defaults = {
                    formatter = "path.filename_first", -- ファイル名を先頭に表示
                    path_shorten = 5, -- パス長を短縮
                },
                keymap = {
                    fzf = {
                        ["tab"] = "down", -- Tabキーで下に移動
                        ["shift-tab"] = "up", -- Shift+Tabキーで上に移動
                    }
                }
            })

            -- ノーマルモードでのキーマッピング設定用の関数
            local nmap = function(keys, func, desc)
                if desc then
                    desc = '[Fzf]' .. desc
                end
                vim.keymap.set('n', keys, func, { desc = desc })
            end

            -- ctagsファイルを作成する関数
            local create_ctags = function()
                -- universal ctagsのインストールが必要
                local cmd = 'ctags --extras=+q --langmap=java:.cls.trigger -f ./tags -R **/main/default/classes/**'
                vim.fn.jobstart(cmd, {
                    on_exit = function(_, code, _)
                        if code == 0 then
                            vim.notify("Tags updated successfully.", vim.log.levels.INFO)
                        else
                            vim.notify("Error updating tags.", vim.log.levels.ERROR)
                        end
                    end
                })
            end

            local fzf = require('fzf-lua')

            -- ファイル操作関連のキーマッピング（<leader>f + 文字）
            nmap('<leader>ff', fzf.files, 'ファイル') -- ファイル検索
            nmap('<leader>fr', fzf.resume, '検索を再開') -- 前回の検索を再開
            nmap('<leader>fd', fzf.diagnostics_document, '診断情報') -- 診断情報
            nmap('<leader>fD', function() fzf.files({ cwd = vim.fn.stdpath 'config' }) end, '設定ファイル') -- 設定ファイル
            nmap('<leader>fb', fzf.buffers, 'バッファ') -- バッファ一覧
            nmap('<leader>.', fzf.oldfiles, '最近のファイル') -- 最近使用したファイル

            -- 検索関連のキーマッピング（グローバル検索、単語検索など）
            nmap('<leader>fg', fzf.grep, 'テキスト検索') -- テキスト検索
            nmap('<leader>fw', fzf.grep_cword, 'プロジェクト内の単語') -- カーソル下の単語をプロジェクト内で検索
            nmap('<leader>fW', fzf.grep_cWORD, '現在の単語') -- カーソル下の単語（拡張）を検索
            nmap("<leader>fm", fzf.lsp_document_symbols, 'メソッド一覧') -- LSPシンボル一覧
            nmap('<leader>/', fzf.grep_curbuf, '現在のバッファを検索') -- 現在のバッファ内検索

            -- 履歴とヘルプ関連のキーマッピング
            nmap('<leader>fc', fzf.command_history, 'コマンド履歴') -- コマンド履歴
            nmap('<leader>fh', fzf.helptags, 'ヘルプ') -- ヘルプタグ

            -- Git関連のキーマッピング（<leader>g + 文字）
            nmap('<leader>gf', fzf.git_files, 'Gitファイル') -- Gitファイル
            nmap('<leader>gc', fzf.git_commits, 'Gitコミット') -- Gitコミット履歴
            nmap('<leader>gC', fzf.git_bcommits, 'このバッファのGitコミット') -- このバッファのコミット履歴
            nmap('<leader>gb', fzf.git_branches, 'Gitブランチ') -- Gitブランチ

            -- ctagsを使用したタグ検索（universal-ctagsが必要）
            nmap('<leader>ft', function()
                create_ctags()
                fzf.tags()
            end, 'プロジェクト内のctag') -- プロジェクト内のctag検索

            -- zoxideを使用したディレクトリ変更（smart cd - zoxideのインストールが必要）
            nmap('<leader>z', function()
                fzf.fzf_exec("zoxide query -ls", {
                    prompt = 'Set cwd() > ',
                    actions = {
                        ['default'] = function(selected)
                            local dir = selected[1]:match("([^%s]+)$")
                            vim.fn.chdir(dir)
                        end
                    }
                })
            end, 'zで作業ディレクトリ設定') -- zoxideを使用した作業ディレクトリ設定

            -- ビジュアルモードでの検索（選択テキストでgrep）
            vim.keymap.set('x', '<leader>fv', fzf.grep_visual, { desc = '[Fzf]選択テキストを検索' })
        end
    }
}
