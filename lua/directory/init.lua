local Log = require("directory.log")
local log = Log.log
local utils = require("directory.utils")

DirectoryConfig = DirectoryConfig or {}

local M = {}

local function find_current_project()
	for key in pairs(DirectoryConfig.projects) do
		if utils.current_directory_contains(key) then
			return DirectoryConfig.projects[key]
		end
	end
	return nil
end

local function find_current_dir(project)
	for i = 1, table.getn(project) do
		local current_dir = project[i]
		if current_dir and utils.current_directory_contains(current_dir.match) then
			return current_dir
		end
	end
	return nil
end

function M.setup(config)
	log.trace("setup(): Setting up...")

	if not config then
		config = {}
	end

	local complete_config = utils.merge_tables({
		projects = {},
		global_settings = {
			["default_buffer"] = "e .",
			["save_current_buffer"] = true,
		},
	}, config)
	DirectoryConfig = complete_config
	log.debug("setup() finish setup", DirectoryConfig)
end

function M.change_directory(index)
	log.debug("change_directory() changing...", index)
	local project = find_current_project()

	if not project then
		log.debug("change_directory() project not found")
		return
	end

	local new_dir = project[index]
    log.debug("found new_dir", new_dir)

	if not new_dir then
		log.debug("change_directory() directory not found por index ", index)
		return
	end

	local current_dir = find_current_dir(project)
	local save_current_buffer = DirectoryConfig.global_settings.save_current_buffer
	if current_dir and save_current_buffer then
		log.debug("change_directory() saving current buffer ")
		local current_buf_name = vim.api.nvim_buf_get_name(0)
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		current_dir.buffer = {
			name = utils.normalize_path(current_buf_name),
			row = current_cursor_pos[1],
			col = current_cursor_pos[2],
		}
		log.debug("change_directory() current buffer saved ", current_dir.buffer)
	end

	vim.api.nvim_set_current_dir(new_dir.path)
	if new_dir.buffer then
		log.debug("change_directory() updating buffer ", new_dir.buffer)
		local buf_id = vim.fn.bufnr(new_dir.buffer.name, true)
		local set_row = not vim.api.nvim_buf_is_loaded(buf_id)
		vim.api.nvim_set_current_buf(buf_id)
		if set_row and new_dir.buffer.row and new_dir.buffer.col then
			vim.cmd(string.format(":call cursor(%d, %d)", new_dir.buffer.row, new_dir.buffer.col))
		end
		log.debug("change_directory() successfully updated buffer ", new_dir.buffer)
	else
		vim.cmd(DirectoryConfig.global_settings.default_buffer)
		log.debug("change_directory() set default buffer", DirectoryConfig.global_settings.default_buffer)
	end

	if DirectoryConfig.global_settings.after_change then
		log.debug("change_directory() running after_change")
		DirectoryConfig.global_settings.after_change()
		log.debug("change_directory() finished after_change")
	end
end

return M
