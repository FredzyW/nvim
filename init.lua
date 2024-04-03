vim.opt.wrap = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.o.termguicolors = true
vim.wo.relativenumber = true
vim.wo.number = true
vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup("plugins")

vim.keymap.set('n', 'z', '<Plug>(leap)')
vim.keymap.set('n', 'Z', '<Plug>(leap-from-window)')
vim.keymap.set({ 'x', 'o' }, 'z', '<Plug>(leap-forward)')
vim.keymap.set({ 'x', 'o' }, 'Z', '<Plug>(leap-backward)')

-- Harpoon
vim.keymap.set('n', '<Space>ha', ':lua require("harpoon.mark").add_file()<CR>')
vim.keymap.set('n', '<Space>hf', ':Telescope harpoon marks<CR>')
vim.keymap.set('n', '<Space>he', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
vim.keymap.set('n', '<Space>hn', ':lua require("harpoon.ui").nav_next()<CR>')
vim.keymap.set('n', '<Space>hb', ':lua require("harpoon.ui").nav_prev()<CR>')

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

vim.opt.termguicolors = true

-- Define a function to generate keybinds for navigating to files
local function setup_file_navigation_keybinds(start, stop)
    for i = start, stop do
        local keybind = string.format('<Space>h%d', i)
        local command = string.format(':lua require("harpoon.ui").nav_file(%d)<CR>', i)
        vim.keymap.set('n', keybind, command)
    end
end

setup_file_navigation_keybinds(1, 9)

require'fzf_lsp'.setup()

require("autoclose").setup({
	keys = {
		["$"] = { escape = true, close = true, pair = "$$", disabled_filetypes = { "haskell" } },
		["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = { "markdown" } },
		["`"] = { escape = true, close = true, pair = "``", disabled_filetypes = { "markdown" } },
	},
})


require('bqf').setup()
require("ibl").setup()
require("focus").setup()
require("bufferline").setup()

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.csharp = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-c-sharp", -- local path or git repo
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    branch = "master", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "cs", -- if filetype does not match the parser name
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "haskell", "python", "bash", "clojure",  "nix", "dockerfile", "latex", "csharp", "markdown", "json", "vue", "typescript" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },

  highlight = {
    enable = true,

    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}



local function lsp()
	local clients = vim.lsp.buf_get_clients()
	if next(clients) == nil then
		return
	end

	for _, client in pairs(clients) do
		return ("[" .. client.name .. "]")
	end
end

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'base16',
		component_separators = { left = '|', right = '|' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = { 'neo-tree' },
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { lsp },
		lualine_y = { 'filetype' },
		lualine_z = {}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

local opts = { noremap = true, silent = true }

-- Substitute
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- Move commands
vim.keymap.set('n', '<Super-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<Super-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('v', '<Super-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<Super-k>', ':MoveBlock(-1)<CR>', opts)

-- Good navigation mappings for wrap
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- Window navigation
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { silent = true })

vim.api.nvim_set_keymap('n', '<Space>c', ':bd<CR>', { silent = true })

-- Sniprun
vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', '<Plug>SnipRun', { silent = true })

-- Highlight yanked
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight_yank', {}),
	desc = 'Hightlight selection on yank',
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
	end,
})

local builtin = require('telescope.builtin')

require("telescope").load_extension('harpoon')

-- Telescope bindings
vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>fb', builtin.buffers, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})


-- Bindings for save and quit
vim.api.nvim_set_keymap('n', '<Space>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>q', ':q<CR>', {})

-- Neotree bindings
vim.api.nvim_set_keymap('n', '<Space>e', ':RnvimrToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_var('rnvimr_enable_ex', 1)
vim.api.nvim_set_var('rnvimr_enable_picker', 1)
vim.api.nvim_set_var('rnvimr_edit_cmd', 'drop')
vim.api.nvim_set_var('rnvimr_draw_border', 0)
vim.api.nvim_set_var('rnvimr_hide_gitignore', 1)
vim.api.nvim_set_var('rnvimr_border_attr', {fg = 14, bg = -1})
vim.api.nvim_set_var('rnvimr_enable_bw', 1)
vim.api.nvim_set_var('rnvimr_shadow_winblend', 70)
vim.api.nvim_set_var('rnvimr_ranger_cmd', {'ranger', '--cmd=set draw_borders both'})


-- LSP Setup
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)
require 'lspconfig'.hls.setup {}
require 'lspconfig'.omnisharp.setup {
	cmd = { "/home/fw/.nix-profile/bin/dotnet", "/nix/store/p5yhca81428vblxy036hpl6j62jnyscy-home-manager-path/lib/omnisharp-roslyn/OmniSharp.dll" },
}
require 'lspconfig'.clojure_lsp.setup {}
require 'lspconfig'.nil_ls.setup {}
require 'lspconfig'.marksman.setup {}
require 'lspconfig'.pylsp.setup {}
require 'lspconfig'.bashls.setup {}
require 'lspconfig'.dockerls.setup {}
require 'lspconfig'.docker_compose_language_service.setup {}
require 'lspconfig'.ansiblels.setup {}
require 'lspconfig'.yamlls.setup {}
require 'lspconfig'.lua_ls.setup {
	settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
require'lspconfig'.vls.setup{}
require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
require'lspconfig'.vuels.setup{}
require'lspconfig'.jsonls.setup{}


require("catppuccin").setup({
	flavour = "macchiato",
	background = {
		light = "latte",
		dark = "mocha",
	},
	transparent_background = false,
	show_end_of_buffer = false,
	term_colors = false,
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	no_italic = false,
	no_bold = false,
	no_underline = false,
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {},
	custom_highlights = {},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = false,
		mini = {
			enabled = true,
			indentscope_color = "",
		},
	},
})

vim.cmd('colorscheme base16-catppuccin-macchiato')

local cmp = require('cmp')

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	mapping = {
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-e>'] = cmp.mapping.abort(),
		['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
		['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
		['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = 'insert' })
			else
				cmp.complete()
			end
		end),
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = 'insert' })
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})

-- require'luasnip'.filetype_extend("csharp")
-- require("luasnip.loaders.from_vscode").lazy_load()
