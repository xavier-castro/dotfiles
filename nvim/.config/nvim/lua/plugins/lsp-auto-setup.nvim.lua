-- Plugin: Massolari/lsp-auto-setup.nvim
-- Installed via store.nvim

return {
  "Massolari/lsp-auto-setup.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = true,
  -- Those are the default options, you don't need to provide them if you're happy with the defaults
  opts = {
    -- Table of server-specific configuration functions
    server_config = {},
    -- List of server names to exclude from auto-setup
    exclude = {},
    -- Cache configuration
    cache = {
      enable = true, -- Enable/disable caching of server names
      ttl = 60 * 60 * 24 * 7, -- Time-to-live for cached server names (in seconds), default is 1 week
      path = vim.fn.stdpath("cache") .. "/lsp-auto-setup/servers.json", -- Path to the cache file
    },
    -- Stop servers that are not attached to any buffer. When a buffer is closed, the server attached to it will be stopped if it's not attached to any other buffer
    stop_unused_servers = {
      enable = true, -- Enable/disable stopping of unused servers
      exclude = {}, -- List of server names to exclude from stopping
    },
  },
}

