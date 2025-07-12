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
		-- 次のバッファに移動
		{ "<C-l>", "<Cmd>BufferLineCycleNext<CR>", mode = "n", desc = "次のバッファに移動" },
		-- 前のバッファに移動
		{ "<C-h>", "<Cmd>BufferLineCyclePrev<CR>", mode = "n", desc = "前のバッファに移動" },
		-- バッファを左に移動
		{ "<A-,>", "<Cmd>BufferLineMovePrev<CR>", mode = "n", desc = "バッファを左に移動" },
		-- バッファを右に移動
		{ "<A-.>", "<Cmd>BufferLineMoveNext<CR>", mode = "n", desc = "バッファを右に移動" },
	},
	config = function(_, opts)
		-- `bufferline.nvim` の設定を適用
		require("bufferline").setup(opts)
	end,
}
