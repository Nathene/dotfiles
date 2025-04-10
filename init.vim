
" ----------------------------------------------------------------------------
" Basic Settings
" ----------------------------------------------------------------------------
set number                     " Show line numbers
set relativenumber             " Show relative line numbers
set tabstop=4                  " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4               " Number of spaces to use for each step of (auto)indent
set expandtab                  " Use spaces instead of tabs
set smartindent                " Insert indents automatically
set ignorecase                 " Ignore case when searching
set smartcase                  " Ignore case only when the search pattern is all lowercase
set scrolloff=8                " Keep 8 lines visible above/below cursor when scrolling
set termguicolors              " Enable true color support
set encoding=utf-8             " Set default encoding to UTF-8
set hidden                     " Allow buffer switching without saving
set wrap!                      " Toggle line wrapping
set mouse=a                    " Enable mouse support
set completeopt=menuone,noselect " Autocomplete options

" Leader key
let mapleader = " "
let maplocalleader = " "

" ----------------------------------------------------------------------------
" vim-plug Plugin Manager Setup
" ----------------------------------------------------------------------------
" Auto-install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start plugin definitions
call plug#begin('~/.local/share/nvim/plugged')

" Core / Utilities
Plug 'nvim-lua/plenary.nvim'                 " Lua utility functions, required by Telescope, etc.
Plug 'nvim-tree/nvim-web-devicons'          " File icons

" Theme
Plug 'morhetz/gruvbox'                      " Gruvbox theme

" UI / Statusline / File Tree
Plug 'nvim-lualine/lualine.nvim'             " Statusline
Plug 'nvim-tree/nvim-tree.lua'              " File explorer tree

" Fuzzy Finding
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' } " Fuzzy finder

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Better syntax highlighting and more

" LSP (Language Server Protocol)
Plug 'neovim/nvim-lspconfig'                " Core LSP configuration
Plug 'williamboman/mason.nvim'                " LSP installer/manager (replaces nvim-lsp-installer)
Plug 'williamboman/mason-lspconfig.nvim'    " Bridge between mason and lspconfig

" Autocompletion
Plug 'hrsh7th/nvim-cmp'                     " Autocompletion engine
Plug 'hrsh7th/cmp-nvim-lsp'                 " LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'                   " Buffer completion source
Plug 'hrsh7th/cmp-path'                     " Path completion source
Plug 'hrsh7th/cmp-cmdline'                  " Command line completion source

" Snippets
Plug 'L3MON4D3/LuaSnip' 
Plug 'saadparwaiz1/cmp_luasnip'              " Snippet completion source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'         " Collection of snippets

" Language Specific
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go development plugin suite

" AI Completion
Plug 'github/copilot.vim'                   " GitHub Copilot

" End plugin definitions
call plug#end()

" ----------------------------------------------------------------------------
" Theme Configuration
" ----------------------------------------------------------------------------
set background=dark " Or 'light'
colorscheme gruvbox

" ----------------------------------------------------------------------------
" Plugin Configurations (Lua)
" ----------------------------------------------------------------------------

lua << EOF
-- Global options for Lua modules if needed
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Setup nvim-web-devicons (needed by lualine, nvim-tree)
require('nvim-web-devicons').setup {
 default = true;
}

-- Setup lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'nvim-tree'}
}

-- Setup nvim-tree
require("nvim-tree").setup { -- <<< NO parenthesis here
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
        },
        git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
        },
      },
    },
  }, -- Closes renderer table
  filters = {
    dotfiles = false, -- Show dotfiles
  }, -- Closes filters table
  update_focused_file = {
      enable = true,
      update_root = true
  }, -- Closes update_focused_file table
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  }, -- Closes diagnostics table
} -- <<< NO parenthesis here, just the closing brace for the main setup table

-- Setup Telescope
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
       n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["q"] = actions.close,
      }
    }
  }
}

-- Setup Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "vim", "go", "python", "rust", "javascript", "typescript", "html", "css", "json", "yaml", "markdown", "bash" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  indent = {
      enable = true -- Enable indentation based on treesitter
  }
}

-- Setup Mason
require("mason").setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    -- List of servers to ensure are installed
    ensure_installed = {
        "gopls",        -- Go
        "lua_ls",       -- Lua (sumneko_lua)
        "pyright",      -- Python
        "bashls",       -- Bash
        "jsonls",       -- JSON
        "yamlls",       -- YAML
        "html",         -- HTML
        "cssls",        -- CSS
    },
    -- Automatic installation (if not already installed)
    automatic_installation = true,
})


-- Setup LSP Config
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>d', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- Set keymap for Go specific LSP features if client is gopls
   if client.name == "gopls" then
        -- If you prefer LSP over vim-go for definitions etc.
        vim.keymap.set("n", "<leader>gs", ":GoSameIdsToggle<CR>", bufopts)
        vim.keymap.set("n", "<leader>gv", ":GoVet<CR>", bufopts)
        vim.keymap.set("n", "<leader>gi", ":GoImplements<CR>", bufopts)
        -- Add more gopls specific commands if needed
   end
end

-- Use capabilities from cmp_nvim_lsp
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Loop through servers installed via mason-lspconfig and setup lspconfig
local servers = require("mason-lspconfig").get_installed_servers() -- Get list from mason
for _, server_name in ipairs(servers) do
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    -- Special settings for specific LSPs
    if server_name == "lua_ls" then
        opts.settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = {'vim'} },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false }
            }
        }
    end
    if server_name == "gopls" then
         opts.settings = {
             gopls = {
                -- Example: enable staticcheck analysis
                analyses = {
                    staticcheck = true,
                },
                -- Use semantic tokens (requires Neovim 0.7+)
                usePlaceholders = true, -- if you want argument placeholders
                staticcheck = true, -- enable staticcheck
                -- Add other gopls settings here if needed
             }
         }
         -- Disable vim-go definition mapping if using LSP for it
         vim.g.go_def_mapping_enabled = 0
    end

    lspconfig[server_name].setup(opts)
end


-- Setup luasnip
local luasnip = require('luasnip')
-- Load snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()


-- Setup nvim-cmp
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
    ['<C-e>'] = cmp.mapping.abort(),      -- Close completion
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept selected suggestion
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For snippets
    { name = 'buffer' },  -- For buffer word completion
    { name = 'path' }     -- For path completion
  })
})

-- Setup nvim-cmp for command line
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup Copilot specific options if needed (Often works out of the box)
-- Example: disable auto-trigger, enable manual trigger with <C-g>
-- vim.g.copilot_auto_tab_completion = false
-- vim.cmd [[imap <silent><script><expr> <C-g> copilot#Accept("\<CR>")]]

-- Setup vim-go (most config is handled by LSP now, but some vim-go features remain)
vim.g.go_fmt_command = "goimports" -- Use goimports for formatting
vim.g.go_metalinter_autosave = 1
vim.g.go_metalinter_enabled = {'vet', 'golint', 'errcheck'}
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_build_constraints = 1
-- Disable vim-go completion if using nvim-cmp primarily
vim.g.go_code_completion_enabled = 0

EOF

" ----------------------------------------------------------------------------
" Key Mappings
" ----------------------------------------------------------------------------
" NvimTree Toggle
nnoremap <silent> <leader>e :NvimTreeToggle<CR>
nnoremap <silent> <leader>o :NvimTreeFocus<CR>

" Telescope Mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Vim-go Mappings (Examples - customize as needed, some may overlap with LSP)
" Note: LSP mappings are defined in the lua on_attach function above
nnoremap <leader>gr :GoRun<CR>
nnoremap <leader>gt :GoTest<CR>
nnoremap <leader>gc :GoCoverageToggle<CR>
" nnoremap <leader>gd :GoDef<CR> " Often handled by LSP 'gd' now

" Copilot (Example - customize or use defaults)
" nnoremap <leader>cp :Copilot panel<CR>

" Basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize splits
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>

" ----------------------------------------------------------------------------
" Autocommands
" ----------------------------------------------------------------------------
" Highlight on yank
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}

" Remove trailing whitespace on save for specific filetypes
autocmd BufWritePre *.go,*.py,*.js,*.ts,*.lua,*.sh,*.md silent! %s/\s\+$//e

" Go specific autocommands (if needed beyond LSP formatting)
" autocmd BufWritePre *.go :silent! GoImports

" Remember last cursor position
autocmd BufReadPost *
     \ if line("'\"") > 1 && line("'\"") <= line("$") |
     \   execute "normal! g`\"" |
     \ endif

" Check if we need to reload the file when it changed
set autoread

" ----------------------------------------------------------------------------
" Final settings
" ----------------------------------------------------------------------------
lua << EOF
local function ToggleLspHoverSimple()
  -- Check if a floating preview window is likely visible
  -- We can try to find one like before, or just *try* to close first.
  -- Let's try closing first. The function handles cases where no window exists.

  -- Attempt to close any existing LSP floating preview.
  -- This function checks if the *current* window is a float and closes it.
  -- If focus is *not* on the float, this won't work directly.
  -- We need a more robust way to find and close *any* LSP float.

  -- Let's refine the find_lsp_hover_float and combine:
  local function find_and_close_lsp_hover_float()
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(winid)
        if config.relative ~= '' and config.external == false then -- Check if it's an internal float
          local bufnr = vim.api.nvim_win_get_buf(winid)
          -- Check buffer properties, or maybe a property set by LSP util?
          local ft = vim.bo[bufnr].filetype
          if vim.bo[bufnr].buftype == 'nofile' and (ft == 'markdown' or ft == 'hover' or ft == 'lspinfo') then
             vim.api.nvim_win_close(winid, true)
             return true -- Indicate we closed a window
          end
        end
      end
      return false -- Indicate no window was closed
  end

  if find_and_close_lsp_hover_float() then
     -- We closed a window, do nothing else
     return
  else
     -- No hover window found/closed, so open one
     vim.lsp.buf.hover()
  end
end

-- In on_attach or globally:
vim.keymap.set('n', '<leader>q', ToggleLspHoverSimple, { noremap=true, silent=true, desc="Toggle LSP Hover"})
vim.keymap.set('n', 'K', ToggleLspHoverSimple, { noremap=true, silent=true, desc="Toggle LSP Hover"})
EOF


lua << EOF

EOF
