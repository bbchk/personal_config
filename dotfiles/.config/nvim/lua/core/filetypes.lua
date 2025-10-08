vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		tiltfile = "tiltfile",
		Tiltfile = "tiltfile",
		slim = "slim",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
		["Dockerfile.*"] = "dockerfile",
	},
})
