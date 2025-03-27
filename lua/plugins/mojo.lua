-- Load the LSP.
require("lspconfig").mojo.setup({ cmd = "mojo-lsp-server -I." })

-- Load the async make.
require("local/mojo_async_make").setup()

--Keybings for async make.
vim.keymap.set("n", "<leader>m", "<cmd>MojoMake<cr>", { desc = "Mojo Make" })

return {}
