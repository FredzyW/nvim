return {
	{
		'm4xshen/autoclose.nvim',
	},
	{
	  'mrjones2014/legendary.nvim',
	  -- since legendary.nvim handles all your keymaps/commands,
	  -- its recommended to load legendary.nvim before other plugins
	  priority = 10000,
	  lazy = false,
	  -- sqlite is only needed if you want to use frecency sorting
	  -- dependencies = { 'kkharji/sqlite.lua' }
	},
	{
		'github/copilot.vim',
	},
	{
		"BurntSushi/ripgrep",
	},
	{
		'kevinhwang91/rnvimr',
	},
	{
		'ThePrimeagen/harpoon',
	},
	{
		'ggandor/leap.nvim',
	},
	{
		'gfanto/fzf-lsp.nvim',
	},
	{
		'RRethy/base16-nvim',
	},
	{
		"folke/which-key.nvim",
	},
	{
		"folke/neodev.nvim",
	},
	{
		"mfussenegger/nvim-dap",
	},
	{
		'neovim/nvim-lspconfig'
	},
	{
		'hrsh7th/cmp-nvim-lsp'
	},
	{
		'hrsh7th/nvim-cmp'
	},
	{
		'nvim-focus/focus.nvim',
		version = false
	},
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf"
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {}
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x'
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000
	},
	{
		'kevinhwang91/nvim-bqf'
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons'
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	},
	{ "junegunn/fzf" },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
          "molleweide/LuaSnip-snippets.nvim",
		  "saadparwaiz1/cmp_luasnip"
		},
		build = "make install_jsregexp"
	},
	{
		"gbprod/substitute.nvim",
		opts = {}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},
	{
		"michaelb/sniprun",
		branch = "master",
		build = "sh install.sh",
		config = function()
			require("sniprun").setup({})
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	{
		'mrcjkb/haskell-tools.nvim',
		version = '^3',
		ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		'numToStr/Comment.nvim',
		opts = {},
		lazy = false,
	},
}
