-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--vim.keymap.set("n", "<leader>jr", function()
--  vim.cmd("split | terminal javac % && java " .. vim.fn.expand("%:t:r"))
--end, { desc = "Java Run" })

--vim.keymap.set("n", "<leader>mt", function()
--  require("utils.markdown").insert_table()
--end, {
--  desc = "Insert Markdown Table",
--})
--
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function java_package_name()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 40, false)) do
    local pkg = line:match("^%s*package%s+([%w%.]+)%s*;")
    if pkg then
      return pkg
    end
  end
end

local function java_src_root(file, pkg)
  local dir = vim.fn.fnamemodify(file, ":h")
  if not pkg then
    return dir
  end
  local pkg_path = pkg:gsub("%.", "/")
  if dir:sub(-#pkg_path) == pkg_path then
    return dir:sub(1, #dir - #pkg_path - 1)
  end
  return dir
end

local function shell_join(parts)
  return table.concat(vim.tbl_map(vim.fn.shellescape, parts), " ")
end

local function run_java()
  if vim.bo.filetype ~= "java" then
    vim.notify("Current file is not Java", vim.log.levels.WARN)
    return
  end

  vim.cmd("silent update")

  local file = vim.fn.expand("%:p")
  local class_name = vim.fn.expand("%:t:r")
  local pkg = java_package_name()
  local main_class = pkg and (pkg .. "." .. class_name) or class_name
  local src_root = java_src_root(file, pkg)
  local out_dir = vim.fn.stdpath("cache") .. "/java-run"
  local project_root = vim.fs.root(file, {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
  })

  vim.fn.mkdir(out_dir, "p")

  local cmd
  if project_root and vim.fn.filereadable(project_root .. "/pom.xml") == 1 then
    cmd = string.format(
      "mvn -q -f %s compile exec:java -Dexec.mainClass=%s",
      vim.fn.shellescape(project_root .. "/pom.xml"),
      vim.fn.shellescape(main_class)
    )
  elseif project_root and vim.fn.executable(project_root .. "/gradlew") == 1 then
    cmd = shell_join({ project_root .. "/gradlew", "-q", "run", "-p", project_root })
  else
    local source = file
    if pkg then
      source = src_root .. "/" .. pkg:gsub("%.", "/") .. "/" .. vim.fn.fnamemodify(file, ":t")
    end
    cmd = string.format(
      "javac -encoding UTF-8 -d %s %s && java -cp %s %s",
      vim.fn.shellescape(out_dir),
      vim.fn.shellescape(source),
      vim.fn.shellescape(out_dir),
      vim.fn.shellescape(main_class)
    )
  end

  Snacks.terminal.open(cmd, {
    cwd = project_root or src_root,
    auto_close = false,
    win = { position = "bottom" },
  })
end

-- Cmd+Shift+R. Terminals often swallow Super/Command, so <leader>jr is the fallback.
vim.keymap.set({ "n", "i" }, "<D-S-r>", run_java, { desc = "Run Java" })
vim.keymap.set({ "n", "i" }, "<D-R>", run_java, { desc = "Run Java" })
vim.keymap.set("n", "<leader>jr", run_java, { desc = "Run Java" })
