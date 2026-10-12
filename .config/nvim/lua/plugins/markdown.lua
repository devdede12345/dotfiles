return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,

    init = function()
      vim.g.mkdp_math = 1
      vim.g.mkdp_browser = "chrome.exe"
    end,
  },
}
