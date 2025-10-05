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
						-- A more efficient and robust function to get the Git repository's root directory name.
						function()
							-- Helper function to run a shell command and return its output,
							-- trimmed of any leading/trailing whitespace.
							-- Returns nil if the command fails or produces no output.
							local function run_cmd(cmd)
								local handle = io.popen(cmd .. " 2>/dev/null") -- Redirect stderr to null
								if not handle then
									return nil
								end
								local output = handle:read("*a")
								handle:close()

								if output and output ~= "" then
									-- Trim whitespace (including the trailing newline)
									return output:match("^%s*(.-)%s*$")
								end
								return nil
							end

							-- Helper function to extract the last component of a path (basename).
							local function basename(path)
								if not path then
									return nil
								end

                for part in path:gmatch("[^/]+") do
                  if part:match("%.git$") then
                    return part:sub(1, -5)  -- Strip the last 4 characters (".git")
                  end
                end

                return path:match("([^/]+)$")
              end

							local git_root = run_cmd("git rev-parse --show-toplevel")

							if not git_root then
								return "" -- Not in a git repo or git command failed, show nothing.
							end

							local repo_name = basename(git_root)
							if repo_name then
								-- Note: Ensure you have a Nerd Font installed for the '' icon to display correctly.
								return "⌂ " .. repo_name
							end

							return "" -- Fallback in case basename fails.
						end,
						color = { fg = "#A6E22E", bg = "transparent" },
					},
					{
						"branch",
						color = { fg = "#A6E22E", bg = "transparent" },
					},
				},
				lualine_c = {
					{
						"location",
						color = { fg = "#A6E22E", bg = "#2E3440" },
					},
				},

				lualine_x = {
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
