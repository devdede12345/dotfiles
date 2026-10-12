local M = {}

local AUTHOR = "Xitong Zhou"
local EMAIL = "xzhou623@wisc.edu"
local COURSE = "CS300, Fall 2026"
local DEFAULT_ASSIGNMENT = "[Assignment chapter/name/number]"
local DEFAULT_CITATIONS = "[any collaboration, assistance or resources; for example:]"

local function header_lines(assignment, citations)
  return {
    "/*",
    " * Author: " .. AUTHOR,
    " * Email: " .. EMAIL,
    " * Course: " .. COURSE,
    " * Assignment: " .. assignment,
    " * Citations: " .. citations,
    " */",
    "",
  }
end

local function buf_has_header(buf)
  local first = vim.api.nvim_buf_get_lines(buf, 0, 10, false)
  return table.concat(first, "\n"):find("Author:%s*" .. AUTHOR, 1, false) ~= nil
end

local function buf_is_empty(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 0 or (#lines == 1 and lines[1] == "")
end

---@param opts? { prompt?: boolean, only_empty?: boolean, buf?: integer }
function M.insert(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if vim.bo[buf].filetype ~= "java" then
    vim.notify("Current file is not Java", vim.log.levels.WARN)
    return
  end

  if opts.only_empty and not buf_is_empty(buf) then
    return
  end

  if buf_has_header(buf) then
    if not opts.only_empty then
      vim.notify("Java header already present", vim.log.levels.INFO)
    end
    return
  end

  local assignment = DEFAULT_ASSIGNMENT
  local citations = DEFAULT_CITATIONS

  if opts.prompt then
    local entered_assignment = vim.fn.input("Assignment: ")
    if entered_assignment ~= "" then
      assignment = entered_assignment
    end
    local entered_citations = vim.fn.input("\nCitations: ")
    if entered_citations ~= "" then
      citations = entered_citations
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, 0, false, header_lines(assignment, citations))
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "FileType" }, {
    group = vim.api.nvim_create_augroup("java_cs300_header", { clear = true }),
    callback = function(ev)
      local is_java = ev.event == "FileType" and ev.match == "java"
        or (ev.event == "BufNewFile" and ev.file:match("%.java$"))
      if not is_java then
        return
      end
      M.insert({ buf = ev.buf, only_empty = true })
    end,
  })

  vim.api.nvim_create_user_command("JavaHeader", function()
    M.insert({ prompt = true })
  end, { desc = "Insert CS300 Java header" })

  vim.keymap.set("n", "<leader>jh", function()
    M.insert({ prompt = true })
  end, { desc = "Insert Java header" })

  if vim.bo.filetype == "java" then
    M.insert({ only_empty = true })
  end
end

return M
