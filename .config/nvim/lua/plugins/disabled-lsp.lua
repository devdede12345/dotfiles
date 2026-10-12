return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        home_assistant = { enabled = false },
        vale_ls = { enabled = false },
      },
    },
  },
}
