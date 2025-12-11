return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    filter = function(mapping)
      -- example to exclude mappings without a description
      return mapping.desc and mapping.desc ~= ""
    end,
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>1", desc = "Format Buffer" },
        { "<leader>w", desc = "Save" },
        { "<leader>h", desc = "No highlight" },
        { "<leader>o", desc = "Find symbols" },
        { "<leader>c", desc = "Run Command" },
        { "<leader>t", desc = "Toggle quickfix" },
        { "<leader>F", desc = "Toggle autoformat" },
        { "<leader>l", group = "LSP" },
        { "<leader>lq", desc = "Quick lsp fix" },
        { "<leader>-", desc = "Open File Browser" },
        
        -- Telescope mappings
        { ";", group = "Telescope" },
        { ";f", desc = "Find files" },
        { ";r", desc = "Live grep" },
        { ";t", desc = "Help tags" },
        { ";;", desc = "Resume" },
        { ";e", desc = "Diagnostics" },
        { ";s", desc = "Treesitter" },
        { ";c", desc = "LSP incoming calls" },
        
        -- Buffer navigation
        { "\\\\", desc = "Open buffers" },
        
        -- External programs
        { "<M-o>", desc = "Open Opencode" },
        { "<M-g>", desc = "Open Gemini" },
        { "<M-c>", desc = "Open Claude CLI" },
        
        -- Terminal and navigation
        { "<C-f>", desc = "Tmux sessionizer" },
        { "<C-n>", desc = "Toggle floating terminal / Next quickfix" },
        { "<C-p>", desc = "Previous quickfix" },
        
        -- Terminal mode
        { "<C-x>", desc = "Close floating terminal", mode = "t" },
        
        -- Visual mode
        { "<Tab>", desc = "Indent", mode = "v" },
        { "<S-Tab>", desc = "Unindent", mode = "v" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}