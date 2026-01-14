local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

require("lazy").setup({
  { "folke/tokyonight.nvim", priority = 1000, config = function() vim.cmd.colorscheme("tokyonight-night") end },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() 
      require("nvim-treesitter.configs").setup({ 
        modules = {}, sync_install = false, ignore_install = {},
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "go", "rust", "python" },
        auto_install = true, highlight = { enable = true } 
      }) 
    end 
  },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("nvim-tree").setup({ view = { width = 30 }, renderer = { group_empty = true }, filters = { dotfiles = false } })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
    end
  },
  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      local fzf = require("fzf-lua")
      fzf.setup({ winopts = { preview = { vertical = "up:45%" } } })
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "FZF Files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "FZF Live Grep" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "FZF Buffers" })
    end
  },
  { "neovim/nvim-lspconfig", dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" }, config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ---@diagnostic disable-next-line: missing-fields
        ensure_installed = { "gopls", "rust_analyzer", "pyright", "lua_ls" },
        handlers = {
          function(server_name) require("lspconfig")[server_name].setup({ capabilities = require("cmp_nvim_lsp").default_capabilities() }) end,
          ["rust_analyzer"] = function() require("lspconfig").rust_analyzer.setup({ capabilities = require("cmp_nvim_lsp").default_capabilities(), settings = { ['rust-analyzer'] = { checkOnSave = { command = "clippy" } } } }) end,
          ["lua_ls"] = function() require("lspconfig").lua_ls.setup({ capabilities = require("cmp_nvim_lsp").default_capabilities(), settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }) end,
        }
      })
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({ ['<C-b>'] = cmp.mapping.scroll_docs(-4), ['<C-f>'] = cmp.mapping.scroll_docs(4), ['<C-Space>'] = cmp.mapping.complete(), ['<CR>'] = cmp.mapping.confirm({ select = true }), ['<Tab>'] = cmp.mapping.select_next_item(), ['<S-Tab>'] = cmp.mapping.select_prev_item() }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } })
      })
      vim.api.nvim_create_autocmd('LspAttach', { group = vim.api.nvim_create_augroup('UserLspConfig', {}), callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, opts)
        end
      })
    end
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} }
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
