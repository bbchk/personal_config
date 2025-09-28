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
						"branch",
						color = { fg = "#A6E22E", bg = "transparent" },
					},
					{
						"location",
						color = { fg = "#A6E22E", bg = "#2E3440" },
					},
				},

				lualine_c = {},

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

-- component_separators = { left = "│", right = "│" },
-- section_separators = { left = "│", right = "│" },
-- --
-- -- -- Option 4: A more stylized, tall bar
-- component_separators = { left = "┃", right = "┃" },
-- section_separators = { left = "┃", right = "┃" },
