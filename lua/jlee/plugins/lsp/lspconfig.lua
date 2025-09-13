return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Keymaps for LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references", buffer = ev.buf })
				keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = ev.buf })
				keymap.set(
					"n",
					"gd",
					"<cmd>Telescope lsp_definitions<CR>",
					{ desc = "Go to definition", buffer = ev.buf }
				)
				keymap.set(
					"n",
					"gi",
					"<cmd>Telescope lsp_implementations<CR>",
					{ desc = "Go to implementation", buffer = ev.buf }
				)
				keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = ev.buf })
				keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ desc = "Code action", buffer = ev.buf }
				)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = ev.buf })
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics", buffer = ev.buf })
				keymap.set(
					"n",
					"<leader>D",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					{ desc = "Buffer diagnostics", buffer = ev.buf }
				)
				keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic", buffer = ev.buf })
				keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", buffer = ev.buf })
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", buffer = ev.buf })

				-- Safe inlay hint enabling
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.inlayHintProvider then
					if vim.lsp.inlay_hint and type(vim.lsp.inlay_hint) == "function" then
						vim.lsp.inlay_hint(ev.buf, true)
					end
				end
			end,
		})

		-- LSP capabilities for nvim-cmp
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure diagnostic display
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Optionally change gutter signs
		local signs = { Error = "", Warn = "", Hint = "󰠠", Info = "" }
		for type, icon in pairs(signs) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		-- Setup LSP servers installed by Mason
		local servers = {
			"lua_ls",
			"clangd",
			"pyright",
			"jdtls",
			"kotlin_language_server",
			"gopls",
		}

		for _, server in ipairs(servers) do
			local opts = { capabilities = capabilities }

			if server == "clangd" then
				opts.cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
				}
			elseif server == "pyright" then
				opts.settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				}
			end

			lspconfig[server].setup(opts)
		end
	end,
}
