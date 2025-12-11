return {
  'stevearc/conform.nvim',
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    config = function()
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          go = { 'goimports' }, -- "gofumpt"
          bash = { 'beautysh' },
          sh = { 'beautysh' },
          fish = { 'beautysh' },
          zsh = { 'beautysh' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'eslint' },
          typescriptreact = { 'eslint' },
          astro = { 'prettier' },
          css = { 'prettier' },
          html = { 'prettier' },
          json = { 'jq' },
          jsonc = { 'prettier' },
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          graphql = { 'prettier' },
          -- Conform can also run multiple formatters sequentially
          python = { 'isort', 'black' },
        },
      }
    end
  }
}
