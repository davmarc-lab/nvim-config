-- Define leader key
vim.g.mapleader = " "

-- Execute nvim config before loading
require("mil.configs.configs")
require("mil.configs.keymaps")

-- Start Lazy plugin manager
require("mil.lazy")
