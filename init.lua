require("configs")

-- setup the help system
vim.api.nvim_create_augroup("FiletypeHelp",
        { clear = true } -- Deletes the group if it already exists
)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*/doc/*.txt",
    callback = function()
        vim.bo.filetype = "help"
    end,
    group = "FiletypeHelp", -- The above content belongs to this group
})
