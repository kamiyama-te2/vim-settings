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
                    desc = desc .. ' [Fzf]'
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
            nmap('<leader>ff', fzf.files, 'files') -- ファイル検索
            nmap('<leader>fr', fzf.resume, 'resume') -- 前回の検索を再開
            nmap('<leader>fd', fzf.diagnostics_document, 'diagnostics') -- 診断情報
            nmap('<leader>fD', function() fzf.files({ cwd = vim.fn.stdpath 'config' }) end, 'dotfiles') -- 設定ファイル
            nmap('<leader>fb', fzf.buffers, 'buffers') -- バッファ一覧
            nmap('<leader>.', fzf.oldfiles, 'recent files') -- 最近使用したファイル

            -- 検索関連のキーマッピング（グローバル検索、単語検索など）
            nmap('<leader>fg', fzf.grep, 'grep') -- テキスト検索
            nmap('<leader>fw', fzf.grep_cword, 'word in project') -- カーソル下の単語をプロジェクト内で検索
            nmap('<leader>fW', fzf.grep_cWORD, 'word in current') -- カーソル下の単語（拡張）を検索
            nmap("<leader>fm", fzf.lsp_document_symbols, 'method list') -- LSPシンボル一覧
            nmap('<leader>/', fzf.grep_curbuf, 'search current buffer') -- 現在のバッファ内検索

            -- 履歴とヘルプ関連のキーマッピング
            nmap('<leader>fc', fzf.command_history, 'command history') -- コマンド履歴
            nmap('<leader>fh', fzf.helptags, 'help') -- ヘルプタグ

            -- Git関連のキーマッピング（<leader>g + 文字）
            nmap('<leader>gf', fzf.git_files, 'git files') -- Gitファイル
            nmap('<leader>gc', fzf.git_commits, 'git commits') -- Gitコミット履歴
            nmap('<leader>gC', fzf.git_bcommits, 'git commits this buffer') -- このバッファのコミット履歴
            nmap('<leader>gb', fzf.git_branches, 'git branches') -- Gitブランチ

            -- ctagsを使用したタグ検索（universal-ctagsが必要）
            nmap('<leader>ft', function()
                create_ctags()
                fzf.tags()
            end, 'ctag in project') -- プロジェクト内のctag検索

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
            end, 'z setup cwd') -- zoxideを使用した作業ディレクトリ設定

            -- ビジュアルモードでの検索（選択テキストでgrep）
            vim.keymap.set('x', '<leader>fv', fzf.grep_visual, { desc = 'visual grep [Fzf]' })
        end
    }
}
