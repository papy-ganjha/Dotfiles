-- nvim-treesitter, branche `main` (réécriture complète).
--
-- Contrairement à la branche `master`, ce plugin ne fournit plus de "modules" :
-- il se contente d'installer les parsers et leurs queries. Activer les
-- fonctionnalités nous incombe :
--   * highlight -> `vim.treesitter.start()`, fourni par Neovim lui-même
--   * indent    -> `indentexpr()` de nvim-treesitter (toujours expérimental)
--   * autotag   -> supprimé (nvim-ts-autotag n'est pas installé de toute façon)
local status, ts = pcall(require, "nvim-treesitter")
if not status then
	return
end

ts.setup()

-- Parsers à garder installés. Le build step `:TSUpdate` de lazy les met à jour.
local ensure_installed = {
	"bash",
	"css",
	"csv",
	"dockerfile",
	"git_config",
	"gitcommit",
	"gitignore",
	"html",
	"javascript",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"regex",
	"requirements",
	"rst",
	"scss",
	"ssh_config",
	"starlark",
	"svelte",
	"toml",
	"tsx",
	"typst",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
}

ts.install(ensure_installed)

-- Filetypes qu'on ne veut pas voir colorés par treesitter, parser ou pas.
local no_highlight = {
	dockerfile = true,
}

-- Filetypes où l'indentation treesitter gêne : on garde l'indentexpr de Vim.
local no_indent = {
	dockerfile = true,
	yaml = true,
}

---Un parser est-il chargeable pour ce langage ?
---`language.add` renvoie `true`, ou `nil` + message : il ne lève pas d'erreur.
---@param lang string
---@return boolean
local function has_parser(lang)
	return vim.treesitter.language.add(lang) == true
end

---@param lang string
---@return boolean
local function has_indents_query(lang)
	local ok, query = pcall(vim.treesitter.query.get, lang, "indents")
	return ok and query ~= nil
end

---@param buf integer
---@param lang string
local function enable(buf, lang)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	local ft = vim.bo[buf].filetype

	-- Certains filetypes démarrent déjà treesitter depuis les ftplugin de
	-- Neovim (markdown, lua, help, query) ; rappeler `start` est sans effet
	-- de bord.
	if not no_highlight[ft] then
		pcall(vim.treesitter.start, buf, lang)
	end

	if not no_indent[ft] and has_indents_query(lang) then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

-- Remplacement de `auto_install` : les parsers manquants sont récupérés au
-- premier fichier rencontré, puis le buffer est coloré quand l'installation
-- (asynchrone) se termine.
local available ---@type table<string, true>|nil

---@param lang string
---@return boolean
local function is_available(lang)
	if not available then
		available = {}
		for _, l in ipairs(ts.get_available()) do
			available[l] = true
		end
	end
	return available[lang] == true
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("kenzb_treesitter", { clear = true }),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang then
			return
		end

		if has_parser(lang) then
			enable(ev.buf, lang)
		elseif is_available(lang) then
			ts.install(lang):await(function(err)
				if err then
					return
				end
				vim.schedule(function()
					enable(ev.buf, lang)
				end)
			end)
		end
	end,
})
