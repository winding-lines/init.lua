return {
  {
    -- "scottmckendry/cyberdream.nvim",
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "cyberdream",
      colorscheme = "gruvbox-material",
    },
  },
}
