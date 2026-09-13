-- nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- the editor's behavior
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true

vim.opt.scrolloff = 4

vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
}


-- ***
-- lazy
-- ***
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
    -- Rose Pine
    {
        "rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,

	config = function()
	    require("rose-pine").setup({
	        variant = "main",
		dark_variant = "main",
	    })

	    vim.cmd.colorscheme("rose-pine")
	end,
    },

    -- telescope
    {
        "nvim-telescope/telescope.nvim",

	dependencies = {
            "nvim-lua/plenary.nvim",
	},

	config = function()
	    local builtin = require("telescope.builtin")

	    require("telescope").setup({})

	    vim.keymap.set("n", "<leader>ff", builtin.find_files, {
	        desc = "Find files",
	    })

	    vim.keymap.set("n", "<leader>fb", builtin.buffers, {
	        desc = "Find buffers",
	    })

	    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
	        desc = "Live grep",
	    })

	    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
                desc = "Find document symbols",
	    })

	    vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, {
	        desc = "Find workspace symbols",
	    })
	end,
    },

    -- oil
    {
        "stevearc/oil.nvim",

	config = function()
	    require("oil").setup({
	        default_file_explorer = true,

		view_options = {
		    show_hidden = true,
		},
	    })

	    vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", {
	        desc = "Open filesystem",
	    })
	end,
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",

	branch = "master",
	build = ":TSUpdate",

	config = function()
	    require("nvim-treesitter.configs").setup({
	        ensure_installed = {
		    "c",
		    "cpp",
		    "python",
		    "lua",
		    "vimdoc",
		    "bash",
		    "json",
		    "toml",
		    "yaml",
		    "markdown",
		    "markdown_inline",
		},

		auto_install = true,

		highlight = {
		    enable = true,
		},

		indent = {
		    enable = true,
	        },
	    })
	end,
    },

    -- completion
    {
        "saghen/blink.cmp",

	version = "1.*",

	opts = {
	    enabled = function()
	        return not vim.tbl_contains({
		    "markdown",
		    "text",
		    "gitcommit",
		}, vim.bo.filetype)
	    end,

	    keymap = {
	        preset = "none",

		["<Tab>"] = {
		    "select_next",
		    "fallback",
		},

		["<S-Tab>"] = {
		    "select_prev",
		    "fallback",
		},

		["<C-y>"] = {
		    "accept",
		},

		["<C-e>"] = {
		    "hide",
		    "fallback",
		},
	    },

	    completion = {
	        
	        menu = {
		    auto_show = true,
		},

		list = {
		    selection = {
		        preselect = false,
			auto_insert = false,
		    },
		},

		documentation = {
		    auto_show = true,
		    auto_show_delay_ms = 500,
		},
            },

	    sources = {
	        default = {
	            "lsp",
		    "path",
		    "buffer",
		},
	    },
	},
    },

    -- formatting
    {
        "stevearc/conform.nvim",

	config = function()
	    local conform = require("conform")

	    conform.setup({
	        formatters_by_ft = {
		    c = {
		        "clang_format",
		    },

		    cpp = {
			"clang_format",
		    },

		    python = {
			"ruff_format",
		    },
		},

		format_on_save = {
		    timeout_ms = 1000,
		    lsp_format = "never",
		},
            })

	    vim.keymap.set("n", "<leader>cf", function()
	        conform.format({
		    async = true,
		    lsp_format = "never",
		})
	    end, {
	        desc = "Format file",
	    })
	end,
    },

    -- code context - good for the late night work
    {
        "SmiteshP/nvim-navic",

	config = function()
	    local navic = require("nvim-navic")

	    navic.setup({
	        highlight = true,
		separator = " > ",
		depth_limit = 0,
	    })

	    local enabled = false

	    vim.keymap.set("n", "<leader>tc", function()
	        enabled = not enabled

		if enabled then
		    vim.o.winbar =
		        "%{%v:lua.require'nvim-navic'.get_location()%}"
		else
		    vim.o.winbar = ""
		end
	    end, {
	        desc = "Toggle code context",
	    })

	    vim.api.nvim_create_autocmd("LspAttach", {
	        callback = function(args)
		    local client = vim.lsp.get_client_by_id(args.data.client_id)

		    if client
			and client.server_capabilities.documentSymbolProvider
		    then
			navic.attach(client, args.buf)
		    end
		end,
	    })
	end,
    },

    -- git
    {
	"lewis6991/gitsigns.nvim",

	config = function()
	    require("gitsigns").setup({
		signs = {
		    add          = { text = "+" },
		    change       = { text = "~" },
		    delete       = { text = "_" },
		    topdelete    = { text = "_" },
		    changedelete = { text = "~" },
		    untracked    = { text = "?" },
		},

		signs_staged_enable = true,
		current_line_blame = false,

		current_line_blame_opts = {
		    virt_text = true,
		    virt_text_pos = "eol",
		    delay = 500,
		},

		on_attach = function(bufnr)
		    vim.keymap.set("n", "<leader>tb",
		        "<cmd>Gitsigns toggle_current_line_blame<CR>",
			{
			    buffer = bufnr,
			    desc = "Toggle git blame",
			}
		    )
		end,
	    })
	end,
    },
})

-- lsp
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
    },

    filetypes = {
        "c",
	"cpp",
	"objc",
	"objcpp",
    },

    root_markers = {
        "compile_commands.json",
	"compile_flags.txt",
	"CMakeLists.txt",
	".git",
    },
})

vim.lsp.enable("clangd")

vim.lsp.config("pyright", {
    cmd = {
        "pyright-langserver",
	"--stdio",
    },

    filetypes = {
	"python",
    },

    root_markers = {
	"pyproject.toml",
	"uv.lock",
	".git",
    },
})

vim.lsp.enable("pyright")


-- lsp mappings
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)

	local builtin = require("telescope.builtin")

	local function opts(desc)
	    return {
		buffer = args.buf,
		desc = desc,
	    }
	end

	-- nav
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("go to declaration"))
	vim.keymap.set("n", "gr", builtin.lsp_references, opts("Find references"))
	vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("Find implementations"))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))

	-- editing
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
    end,
})

-- diags
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true, })
end, {
    desc = "Previous diagnostic",
})

vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true, })
end, {
    desc = "Next diagnostic",
})

-- quality of life

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- esc clear /search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

