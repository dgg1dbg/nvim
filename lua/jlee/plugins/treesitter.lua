return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local ts_configs = require("nvim-treesitter.configs")

		ts_configs.setup({
			-- enable syntax highlighting
			highlight = { enable = true },

			-- enable indentation
			indent = { enable = true },

			-- enable autotagging (for html, xml, etc.)
			autotag = { enable = true },

			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"markdown",
				"markdown_inline",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp",
				"python",
				"java",
				"go",
				"gomod",
			},

			-- incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
