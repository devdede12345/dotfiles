local M = {}

function M.insert_table()
  local rows = vim.fn.input("Rows: ")
  local cols = vim.fn.input("Columns: ")

  rows = tonumber(rows)
  cols = tonumber(cols)

  if not rows or not cols then
    print("Invalid input")
    return
  end

  local lines = {}

  -- header
  local header = "|"
  for i = 1, cols do
    header = header .. " Header " .. i .. " |"
  end
  table.insert(lines, header)

  -- separator
  local separator = "|"
  for i = 1, cols do
    separator = separator .. " --- |"
  end
  table.insert(lines, separator)

  -- body
  for r = 1, rows do
    local row = "|"
    for c = 1, cols do
      row = row .. "     |"
    end
    table.insert(lines, row)
  end

  vim.api.nvim_put(lines, "l", true, true)
end

return M
