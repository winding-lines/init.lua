return {
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      condition = function(buf)
        -- don't save for special-buffers
        if vim.fn.getbufvar(buf, "&buftype") ~= "" then
          return false
        end
        return true
      end,
    },
  },
}
