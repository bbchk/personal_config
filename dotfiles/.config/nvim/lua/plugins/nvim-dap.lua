return {
	"mfussenegger/nvim-dap",
	dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
	config = function()
    local dap = require("dap");

    -- keybindings
    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>dc', dap.continue, {})

    -- dap-ui configurations
    local dapui = require("dapui");
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- dap.adapters.python = {
    --   type = 'executable';
    --   command = os.getenv('HOME') .. '/.virtualenvs/tools/bin/python';
    --   args = { '-m', 'debugpy.adapter' };
    -- }
  end,
} 
