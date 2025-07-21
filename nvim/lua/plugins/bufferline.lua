return {
	"akinsho/bufferline.nvim",
	version = "*", -- 最新バージョンを使用
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- アイコン表示用のプラグイン
	},
	event = "VeryLazy",
	opts = {
		options = {
			numbers = "none", -- バッファ番号を非表示
			show_buffer_close_icons = true, -- バッファの閉じるアイコンを表示
			show_close_icon = true, -- 全体の閉じるアイコンを表示
			separator_style = "slant", -- セパレーターのスタイル
		},
	},
	keys = {
		{ "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>", mode = "n", desc = "左のバッファを閉じる" },
        { "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>", mode = "n", desc = "右のバッファを閉じる" },
        { "<Leader>ball", "<Cmd>BufferLineCloseOthers<CR>", mode = "n", desc = "他のバッファを閉じる" },
        { "<Leader>be", "<Cmd>BufferLinePickClose<CR>", mode = "n", desc = "指定したバッファを閉じる" },
		{ "<C-l>", "<Cmd>BufferLineCycleNext<CR>", mode = "n", desc = "次のバッファに移動" },
		{ "<C-h>", "<Cmd>BufferLineCyclePrev<CR>", mode = "n", desc = "前のバッファに移動" },
		{ "<A-,>", "<Cmd>BufferLineMovePrev<CR>", mode = "n", desc = "バッファを左に移動" },
		{ "<A-.>", "<Cmd>BufferLineMoveNext<CR>", mode = "n", desc = "バッファを右に移動" },
	},
	config = function(_, opts)
		-- `bufferline.nvim` の設定を適用
		require("bufferline").setup(opts)
	end,
}
