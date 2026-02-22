-- Aggressively disable built-in plugins for faster startup
local disabled_builtins = {
	"2html_plugin",
	"gzip",
	"matchit",
	"netrw",
	"netrwFileHandlers",
	"netrwPlugin",
	"netrwSettings",
	"rplugin",
	"shada",
	"spellfile",
	"tarPlugin",
	"tohtml",
	"tutor",
	"zipPlugin",
}

for _, plugin in ipairs(disabled_builtins) do
	vim.g["loaded_" .. plugin] = 1
end
