-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
require("config.java-header").setup()

local function chinese_comment_style()
  local hl = vim.api.nvim_get_hl(0, {
    name = "Comment",
    link = false,
  })

  hl.italic = false
  vim.api.nvim_set_hl(0, "@comment.chinese", hl)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = chinese_comment_style,
})

chinese_comment_style()

-- Markdown 和文本文件关闭拼写检查
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_text_spell", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
