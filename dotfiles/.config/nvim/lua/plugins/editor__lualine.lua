-- ~/nvim/lua/slydragonn/plugins/lualine.lua

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
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
						color = { fg = "#FFFF5F", bg = "#2E3440", gui = "bold" },
					},
				},
				lualine_b = {
					{
						function()
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

							local git_root = run_cmd("git rev-parse --show-toplevel")

							if not git_root then
								return ""
							end

							local repo_path = last_two(git_root)
							if repo_path then
								return "⌂ " .. repo_path
							end

							return ""
						end,
						color = { fg = "#A6E22E", bg = "transparent" },
					},
				},
			lualine_c = {
				{
					"location",
					color = { fg = "#A6E22E", bg = "#2E3440" },
				},
				{
					function()
						local file = vim.fn.expand("%:p")
						if file == "" then return "" end
						local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
						if vim.v.shell_error ~= 0 or root == "" then return "" end
						local rel = file:gsub("^" .. vim.pesc(root) .. "/", "")
						local out = vim.fn.system("git check-attr filter -- " .. vim.fn.shellescape(rel) .. " 2>/dev/null")
						if out:match("filter: gpg") then return "🔒" end
						return ""
					end,
					color = { fg = "#e5c07b", bg = "#2E3440" },
				},
			},				lualine_x = {
					{
						function()
							local handle = io.popen('ip a | grep -q ppp0 && echo "vpn" || echo "home"')
							local result = handle:read("*a")
							handle:close()
							return "🖧" .. string.gsub(result, "\n", "")
						end,
						color = { fg = "#A6E22E", bg = "#2E3440" },
					},
				},
				lualine_y = {
					{
						function()
							local handle = io.popen(
								"upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | sed 's/%//'"
							)
							local result = handle:read("*a")
							handle:close()

							return "🗲" .. tostring(tonumber(result))
						end,
						color = { fg = "#A6E22E", bg = "transparent" },
					},
				},
				lualine_z = {
					{
						function()
							return "⏲ " .. os.date("%-I:%-M %p %m/%d")
						end,
						color = { fg = "#A6E22E", bg = "#2E3440" },
					},
				},
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
