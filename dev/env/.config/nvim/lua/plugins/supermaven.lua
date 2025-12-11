return {
  event = "BufEnter",
  "supermaven-inc/supermaven-nvim",
  cmd = { "SupermavenStart", "SupermavenToggle" },
  config = function()
    require("supermaven-nvim").setup({})

    -- Create toggle function with snacks-style configuration
    local function create_toggle(name, get_state, toggle_fn, opts)
      opts = opts or {}
      local icon = opts.icon or { enabled = " ", disabled = " " }
      local color = opts.color or { enabled = "green", disabled = "yellow" }

      return function()
        toggle_fn()
        local enabled = get_state()
        local status = enabled and "enabled" or "disabled"
        local icon_str = enabled and icon.enabled or icon.disabled
        local msg = string.format("%s %s %s", icon_str, name, status)

        vim.notify(msg, vim.log.levels.INFO, { title = "Toggle" })
      end
    end

    -- Transparency toggle
    local toggle_transparency = create_toggle("Transparency", function()
      return vim.g.transparency_enabled or false
    end, function()
      vim.g.transparency_enabled = not (vim.g.transparency_enabled or false)
      if vim.g.transparency_enabled then
        vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
        vim.cmd("hi NonText guibg=NONE ctermbg=NONE")
        vim.cmd("hi SignColumn guibg=NONE ctermbg=NONE")
        vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
      else
        vim.cmd("colorscheme " .. vim.g.colors_name)
      end
    end, { icon = { enabled = "👻", disabled = "🎨" } })

    -- Supermaven toggle with snacks-style feedback
    local toggle_supermaven = create_toggle("Supermaven", function()
      return require("supermaven-nvim.api").is_running()
    end, function()
      require("supermaven-nvim.api").toggle()
    end, { icon = { enabled = "🤖", disabled = "🚫" } })

    -- Register keymaps
    vim.keymap.set("n", "<leader><leader>s", toggle_supermaven, { desc = "Toggle Supermaven" })
    vim.keymap.set("n", "<leader><leader>t", toggle_transparency, { desc = "Toggle Transparency" })
  end,
}
