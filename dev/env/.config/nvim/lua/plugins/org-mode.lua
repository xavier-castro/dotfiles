-- https://github.com/chipsenkbeil/org-roam.nvim
-- https://nvim-orgmode.github.io/plugins

return {
  {
    'nvim-orgmode/orgmode',
    event = 'BufEnter',
    lazy = false,
    priority = 1000,
    dependencies = {
      'danilshvalov/org-modern.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-orgmode/telescope-orgmode.nvim',
      'nvim-orgmode/org-bullets.nvim',
    },

    {
      "michaelb/sniprun",
      branch = "master",

      build = "sh install.sh",
      -- do 'sh install.sh 1' if you want to force compile locally
      -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

      config = function()
        require("sniprun").setup({
          -- your options
        })
      end,
    },
    config = function()
      require('org-bullets').setup()
      -- Pretty Agenda View
      local Menu = require("org-modern.menu")
      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/personal/org/**/*',
        org_default_notes_file = '~/personal/org/refile.org',
        ui = {
          menu = {
            candler = function(data)
              Menu:new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 0, 1, 0, 1 },
                  title_pos = "center",
                  border = "single",
                  zindex = 1000,
                },
                icons = {
                  separator = "➜",
                },
              }):open(data)
            end,
          },
        },
      })

      require('cmp').setup({
        sources = {
          { name = 'orgmode' }
        }
      })

      require('telescope').setup()
      require('telescope').load_extension('orgmode')
      vim.keymap.set('n', '<leader>r', require('telescope').extensions.orgmode.refile_heading)
      vim.keymap.set('n', '<leader>fh', require('telescope').extensions.orgmode.search_headings)
      vim.keymap.set('n', '<leader>li', require('telescope').extensions.orgmode.insert_link)
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    event = "BufEnter",
    lazy = false,
    tag = "0.1.1",
    dependencies = {
      {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
          vim.cmd [[highlight Headline1 guibg=#1e2718]]
          vim.cmd [[highlight Headline2 guibg=#21262d]]
          vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
          vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]

          require("headlines").setup {
            org = {
              headline_highlights = { "Headline1", "Headline2" },
            },
          }
        end -- or `opts = {}`
      },

    },
    config = function()
      require("org-roam").setup({
        directory = "~/personal/org/roam/",
        -- optional
        -- org_files = {
        -- }
      })
    end
  }
}
