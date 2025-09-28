vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard:
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

opt.conceallevel = 1
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()

			-- Stop list if line is just a marker with no text (like "- " or "1. ")
			if line:match("^%s*[-*+]%s*$") or line:match("^%s*%d+%.%s*$") then
				return "<C-u><CR>" -- clear line, then newline
			end

			-- Continue bullet lists (-, *, +)
			local indent, bullet = line:match("^(%s*)([-*+])%s+")
			if bullet then
				return "<CR>" .. indent .. bullet .. " "
			end

			-- Continue numbered lists (1., 2., ...)
			local nindent, num = line:match("^(%s*)(%d+)%.%s+")
			if num then
				return "<CR>" .. nindent .. tostring(tonumber(num) + 1) .. ". "
			end

			-- Normal newline otherwise
			return "<CR>"
		end, { buffer = true, expr = true })
	end,
})
