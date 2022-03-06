local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("directory.nvim requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
    exports = {
        directory = require("telescope._extensions.dirs"),
    },
})
