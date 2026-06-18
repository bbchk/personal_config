return {
  "ErickKramer/nvim-ros2",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    picker = "telescope",
    autocmds = true,
    treesitter = true,
    tuner = true, -- Enables the :RosTune command and hardware proxy
    tuner_match_mode = "smart", -- "smart" (algorithm), "simple" (root keys), or "all" (skip filter)
    tuner_open_mode = "hide",
  },
config = function(_, opts)
    require("nvim-ros2").setup(opts)

    -- RPC Engine Keymaps (Buffer-Local)
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "ROS_CALL_*",
      callback = function(args)
        local bufnr = args.buf
        local map_opts = { buffer = bufnr, silent = true }

        -- Execute the payload
        vim.keymap.set("n", "<CR>", "<cmd>RosRpc send<CR>", vim.tbl_extend("force", map_opts, { desc = "Send RPC Call" }))
        -- Gracefully cancel
        vim.keymap.set("n", "s", "<cmd>RosRpc stop<CR>", vim.tbl_extend("force", map_opts, { desc = "Stop RPC Call" }))
        -- Save with metadata
        vim.keymap.set("n", "<leader>s", "<cmd>RosRpc save<CR>", vim.tbl_extend("force", map_opts, { desc = "Save Payload" }))
        -- Smart Load compatible payloads
        vim.keymap.set("n", "<leader>l", function() require("nvim-ros2.pickers").saved_payloads() end, vim.tbl_extend("force", map_opts, { desc = "Load Payload" }))
        -- Quick exit
        vim.keymap.set("n", "q", "<cmd>q<CR>", vim.tbl_extend("force", map_opts, { desc = "Close RPC Buffer" }))
      end,
    })
  end,
  keys = {
    -- Base Pickers
    { "<leader>li", function() require("nvim-ros2").pickers.interfaces() end, desc = "[ROS 2]: List interfaces" },
    { "<leader>ln", function() require("nvim-ros2").pickers.nodes() end, desc = "[ROS 2]: List nodes" },
    { "<leader>la", function() require("nvim-ros2").pickers.actions() end, desc = "[ROS 2]: List actions" },
    { "<leader>lt", function() require("nvim-ros2").pickers.topics_info() end, desc = "[ROS 2]: List topics with info" },
    { "<leader>le", function() require("nvim-ros2").pickers.topics_echo() end, desc = "[ROS 2]: List topics with echo" },
    { "<leader>ls", function() require("nvim-ros2").pickers.services() end, desc = "[ROS 2]: List services" },

    -- Workspace Navigator
    { "<leader>fp", function() require("nvim-ros2").pickers.packages() end, desc = "[F]ind ROS2 [P]ackage" },
    { "<leader>pf", function() require("nvim-ros2").pickers.find_files_package() end, desc = "Find in Package" },
    { "<leader>pg", function() require("nvim-ros2").pickers.grep_package() end, desc = "Grep in Package" },
    { "<leader>pc", function() require("nvim-ros2").pickers.edit_cmake() end, desc = "Edit CMakeLists.txt" },
    { "<leader>pp", function() require("nvim-ros2").pickers.edit_package_xml() end, desc = "Edit package.xml" },

    -- Snipers
    { "<leader>pm", function() require("nvim-ros2").pickers.sniper("msg") end, desc = "Sniper: msg/" },
    { "<leader>ps", function() require("nvim-ros2").pickers.sniper("srv") end, desc = "Sniper: srv/" },
    { "<leader>pa", function() require("nvim-ros2").pickers.sniper("action") end, desc = "Sniper: action/" },
    { "<leader>pi", function() require("nvim-ros2").pickers.sniper("include") end, desc = "Sniper: include/" },

    -- Tuner
    { "<leader>rt", "<cmd>RosTune<cr>", desc = "Start ROS Tuner" },
    { "<leader>rs", "<cmd>RosTune resync<CR>", desc = "[T]uner [R]esync" },
    { "<leader>rp", "<cmd>RosTune resync --pull<CR>", desc = "[T]uner [P]ull Missing Params" },
  },
}
