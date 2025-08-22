-- Load the LSP.
require("lspconfig").mojo.setup({ cmd = { "mojo-lsp-server", "-I", "." } })

-- Load the async make.
require("local/mojo_async_make").setup()

require("local/mojo_debug").setup()

--Keybings for async make.
vim.keymap.set("n", "<leader>m", "<cmd>MojoMake<cr>", { desc = "Mojo Make" })

-- setup formatting
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      mojo = { "mojo" },
    },
    formatters = {
      mojo = {
        command = "mojo",
        args = { "format", "-" },
        stdin = true,
      },
    },
  },
}
