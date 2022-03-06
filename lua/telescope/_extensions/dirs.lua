local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local directory = require("directory")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

 
local function generate_new_finder() 
    return finders.new_table {
        results = directory.get_directory_config().directories
    }
end

return function(opts)
    opts = opts or {}
    pickers.new(opts, {
        promp_title = "Directories",
        finder = generate_new_finder(),
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    local dir = selection[1]
                    vim.api.nvim_set_current_dir(dir)
		            vim.cmd(directory.get_directory_config().global_settings.default_buffer)
                end
             end)
             return true
         end,    
     }):find()
end
