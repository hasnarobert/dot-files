return {
  -- add onedark
  {
    "navarasu/onedark.nvim",
    opts = {
      colors = { bg0 = "#22252A" },
    },
  },

  -- Configure LazyVim to load onedark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
