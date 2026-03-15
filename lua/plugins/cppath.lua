M = {}

vim.api.nvim_create_user_command("CpPath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("LocalHelp", function()
  vim.cmd("e ~/.local/share/nvim/site/doc/")
end, {})

return M
