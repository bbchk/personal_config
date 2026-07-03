return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")
			local dap_virt_text = require("nvim-dap-virtual-text")

			ui.setup()
			dap_virt_text.setup({})

			-- DAP adapters are installed on PATH by the langtools devcontainer
			-- feature (js-debug-adapter, php-debug-adapter launchers), not mason.
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}

			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
				args = {},
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug",
					port = 9003,
				},
			}

			-- #TODO: pick better color
			vim.api.nvim_set_hl(0, "RedCursor", { fg = "#AF0000", bg = None })
			vim.fn.sign_define("DapBreakpoint", { text = "⦿", texthl = "RedCursor", linehl = "", numhl = "" })

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>e", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F12>", dap.restart)

			vim.keymap.set("n", "<F11>", dap.disconnect)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}

-- TODO: move
-- vim-dap uses five signs:
--
-- - `DapBreakpoint` for breakpoints (default: `B`)
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
--   adapter (default: `R`)
--
-- You can customize the signs by setting them with the |sign_define()| function.
-- For example:
--
--
--
--
-- vim.api.nvim_set_hl(0, 'YellowBack', { bg="#4C4C19" })
-- vim.fn.sign_define('DapStopped', { text='', texthl='YellowCursor', linehl='YellowBack', numhl=''})
--
--
--
--
-- local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
-- if elixir_ls_debugger ~= "" then
-- 	dap.adapters.= {
-- 		type = "executable",
-- 		command = elixir_ls_debugger,
-- 	}
--
-- 	dap.configurations.elixir = {
-- 		{
-- 			type = "mix_task",
-- 			name = "phoenix server",
-- 			task = "phx.server",
-- 			request = "launch",
-- 			projectDir = "${workspaceFolder}",
-- 			exitAfterTaskReturns = false,
-- 			debugAutoInterpretAllModules = false,
-- 		},
-- 	}
-- end
