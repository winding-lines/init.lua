--[[
return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        mojo = {},
      },
    },
  },
}
--]]

require("lspconfig").mojo.setup({})
return {}
