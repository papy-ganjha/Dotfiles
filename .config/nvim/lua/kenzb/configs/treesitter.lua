-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = true,
        disable = {"dockerfile", "markdown"}
	},
	-- enable indentation
	indent = { enable = true, disable = {"dockerfile", "yaml"}},
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"json",
		"yaml",
		"python",
		"markdown",
		"markdown_inline",
		"bash",
		"lua",
		"vim",
		"gitignore",
		"regex",
		"css",
		"html",
		"javascript",
		"scss",
		"svelte",
		"tsx",
		"typst",
		"vue",
	},
	-- auto install above language parsers
	auto_install = true,
})
