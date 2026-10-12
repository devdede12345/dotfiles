-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
vim.opt.laststatus = 0

vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.cursorline = false

vim.g.snacks_indent = false

vim.opt.laststatus = 0 -- 隐藏额外的状态栏
vim.opt.cmdheight = 1 -- 保留一行底部命令区
vim.opt.ruler = true -- 右侧显示行列位置
vim.opt.showcmd = true -- 显示尚未完成的按键命令
vim.opt.showmode = false -- 不显示 -- INSERT --
vim.opt.shortmess:remove("W") -- 显示保存文件的提示

vim.opt.spell = false
