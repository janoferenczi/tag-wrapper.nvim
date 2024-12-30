local M = {}


local function get_selection_limits(vstart, vend)
	return vstart[2], vstart[3], vend[2], vend[3]
end


local function add_tag_to_text(input)
	local startTag = "<" .. input .. ">"
	local endTag   = "</" .. input .. ">"

	-- exit to normal mode, first this needs to be done in order to get the currently selected text
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'x', true)

	-- getting the limits of the current selection
	local vstart = vim.fn.getpos("'<")
	local vend   = vim.fn.getpos("'>")
	local startRow, startCol, endRow, endCol = get_selection_limits(vstart, vend)

	if startRow == endRow then
		endCol = endCol + startTag:len()
	end

	vim.api.nvim_buf_set_text(0, startRow - 1, startCol - 1, startRow - 1, startCol - 1, { startTag })
	vim.api.nvim_buf_set_text(0, endRow - 1, endCol, endRow - 1, endCol, { endTag })
end


local function prompt_user(callback)
	vim.ui.input({ prompt = "Enter a tag: " }, function(input)
		callback(input)
	end)
end


function M.setup(opts)
	opts = opts or {}
	vim.keymap.set("v", "<C-t>", function ()
		prompt_user(add_tag_to_text)
	end)

end

return M
