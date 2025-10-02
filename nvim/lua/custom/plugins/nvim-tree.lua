return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup {
            view = {
                width = 30,
                side = "left",
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
            },
        }

        vim.keymap.set("n", "<leader>e", function()
            local view = require("nvim-tree.view")
            if view.is_visible() then
                view.close()
            else
                vim.cmd("NvimTreeFocus")
            end
        end, { desc = "Toggle File Explorer" })
    end,
}
