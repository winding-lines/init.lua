-- Load the LSP.
require("lspconfig").mojo.setup({})

-- Load the async make.
require("local/mojo_async_make").setup()

--Keybings for async make.
vim.keymap.set("n", "<leader>m", "<cmd>MojoMake<cr>", { desc = "Mojo Make" })

return {}
