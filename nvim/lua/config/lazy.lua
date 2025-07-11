-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "lazy.nvimのクローンに失敗しました:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n何かキーを押して終了..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvimを読み込む前に`mapleader`と`maplocalleader`を設定して
-- キーマッピングが正しく動作するようにする
-- ここは他の設定（vim.opt）を行うのにも適した場所
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- lazy.nvimのセットアップ
require("lazy").setup({
  spec = {
    -- プラグインをインポート
    { import = "plugins" },
  },
  -- その他の設定はここで行う。詳細はドキュメントを参照
  -- プラグインインストール時に使用されるカラースキーム
  install = { colorscheme = { "habamax" } },
  -- プラグイン自動更新チェック
  checker = { enabled = false },
})
