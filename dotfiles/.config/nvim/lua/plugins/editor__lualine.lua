return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Runs a shell command and returns trimmed output, or nil on failure/empty
		local function run_cmd(cmd)
			local handle = io.popen(cmd .. " 2>/dev/null")
			if not handle then
				return nil
			end
			local output = handle:read("*a")
			handle:close()

			if output and output ~= "" then
				return output:match("^%s*(.-)%s*$")
			end
			return nil
		end

		-- Extracts the last two path segments (e.g. "/home/user/projects/myrepo" → "projects/myrepo")
		local function last_two(path)
			if not path then
				return nil
			end

			local parts = {}
			for part in path:gmatch("[^/]+") do
				table.insert(parts, part)
			end

			if #parts >= 2 then
				return parts[#parts - 1] .. "/" .. parts[#parts]
			elseif #parts == 1 then
				return parts[1]
			end

			return nil
		end

		-- lualine_b: shows last two segments of git repo root path
		local function git_repo_component()
			local git_root = run_cmd("git rev-parse --show-toplevel")
			if not git_root then
				return ""
			end

			local repo_path = last_two(git_root)
			if repo_path then
				return "~/" .. repo_path
			end

			return ""
		end

		-- lualine_c: shows a lock icon if current file is filtered through git-crypt/gpg
		local function gpg_lock_component()
			local file = vim.fn.expand("%:p")
			if file == "" then
				return ""
			end
			local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
			if vim.v.shell_error ~= 0 or root == "" then
				return ""
			end
			local rel = file:gsub("^" .. vim.pesc(root) .. "/", "")
			local out = vim.fn.system("git check-attr filter -- " .. vim.fn.shellescape(rel) .. " 2>/dev/null")
			if out:match("filter: gpg") then
				return "🗝"
			end
			return ""
		end

		-- lualine_x: shows whether running inside a container
		local function env_component()
			local in_container = vim.fn.filereadable("/.dockerenv") == 1
				or vim.env.REMOTE_CONTAINERS ~= nil
				or vim.env.DEVCONTAINER ~= nil
				or vim.env.CODESPACES ~= nil
			if in_container then
				return "env: 🛳"
			end
			return "env: 🖳"
		end

		-- lualine_x: shows whether connected via VPN (ppp0) or home network
		local function net_component()
			local handle = io.popen('ip a | grep -q ppp0 && echo "vpn" || echo "home"')
			local result = handle:read("*a"):gsub("\n", "")
			handle:close()

			if result == "vpn" then
				return "net: 🖧"
			end
			return "net: 🖳"
		end

		-- lualine_z: current time
		local function time_component()
			return "🕰 " .. os.date("%I:%M%p")
		end

		-- lualine_z: current date
		local function date_component()
			return "🗓︎ " .. os.date("%m/%d")
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				always_divide_middle = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						color = { fg = "#FFFF5F", bg = "#1B2408", gui = "bold" },
					},
				},
				lualine_b = {
					{
						git_repo_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
				},
				lualine_c = {
					{
						"location",
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},

					{
						gpg_lock_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
				},
				lualine_x = {
					{
						env_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
					{
						net_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
				},
				lualine_y = {
					{
						time_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
					{
						date_component,
						color = { fg = "#A6E22E", bg = "#1B2408" },
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "location" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
