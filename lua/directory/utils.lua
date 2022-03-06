local Path = require("plenary.path")
local Log = require("directory.log")
local log = Log.log

local function merge_table_impl(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k]) == "table" then
				merge_table_impl(t1[k], v)
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
end

local M = {}

function M.contains(str, match)
	return not not (string.find(str, match, 1, true))
end

function M.current_directory_contains(match)
	return M.contains(vim.loop.cwd(), match)
end

function M.merge_tables(...)
	log.trace("_merge_tables()")
	local out = {}
	for i = 1, select("#", ...) do
		merge_table_impl(out, select(i, ...))
	end
	return out
end

function M.normalize_path(path)
	return Path:new(path):make_relative(vim.loop.cwd())
end

return M
