local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
        { import = "mil.plugins.colorscheme" },
        { import = "mil.plugins.core" },
        { import = "mil.plugins.lsp" }, },
    {
        checker = {
            enable = true,
            notify = false,
        },
        change_detection = {
            notify = false,
        },
        ui = {
            border = "none",
            title = "Mil Package Manager",
            title_pos = "center",
            icons = {
                cmd = " ",
                config = "",
                event = "",
                ft = " ",
                init = " ",
                import = " ",
                keys = " ",
                lazy = "󰒲 ",
                loaded = "●",
                not_loaded = "○",
                plugin = " ",
                runtime = " ",
                require = "󰢱 ",
                source = " ",
                start = "",
                task = "✔ ",
                list = {
                    "●",
                    "➜",
                    "★",
                    "‒",
                },
            }
        },
    })
