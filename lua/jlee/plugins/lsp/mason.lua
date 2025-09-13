return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of language servers to install
			ensure_installed = {
				-- Lua
				"lua_ls",

				-- C / C++
				"clangd",

				-- Python
				"pyright",

				-- Java
				"jdtls",

				-- Kotlin
				"kotlin_language_server",

				-- Go
				"gopls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Lua
				"stylua",

				-- Python
				"isort",
				"black",
				"pylint",

				-- C / C++
				"clang-format",

				-- Java
				"google-java-format",

				-- Kotlin
				"ktlint",

				-- Go
				"gofumpt",
				"golines",
				"golangci-lint",
			},
		})
	end,
}
