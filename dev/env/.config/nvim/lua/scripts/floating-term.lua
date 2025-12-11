-- Floating terminal toggle
local float_term_win = nil
local float_term_buf = nil

local function create_floating_terminal()
  -- Create or reuse buffer
  if not float_term_buf or not vim.api.nvim_buf_is_valid(float_term_buf) then
    float_term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(float_term_buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(float_term_buf, "filetype", "terminal")
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Ensure minimum dimensions
  width = math.max(width, 80)
  height = math.max(height, 20)

  -- Create floating window with error handling
  local ok, win_or_err = pcall(vim.api.nvim_open_win, float_term_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Terminal ",
    title_pos = "center",
  })

  if not ok then
    vim.notify("Failed to create floating terminal: " .. win_or_err, vim.log.levels.ERROR)
    return
  end

  float_term_win = win_or_err

  -- Set window options
  vim.api.nvim_win_set_option(float_term_win, "winblend", 0)

  -- Start terminal if buffer is empty
  local line_count = vim.api.nvim_buf_line_count(float_term_buf)
  if line_count <= 1 and vim.api.nvim_buf_get_lines(float_term_buf, 0, -1, false)[1] == "" then
    local shell = os.getenv("SHELL") or "/bin/sh"
    local job_id = vim.fn.termopen(shell, {
      buffer = float_term_buf,
      on_exit = function(_, exit_code)
        -- Clean up when terminal exits
        if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
          vim.api.nvim_win_close(float_term_win, true)
        end
        float_term_win = nil
        -- Only clear buffer if terminal exited normally
        if exit_code == 0 then
          float_term_buf = nil
        end
      end,
    })

    if job_id <= 0 then
      vim.notify("Failed to start terminal", vim.log.levels.ERROR)
      close_floating_terminal()
      return
    end
  end

  -- Enter insert mode
  vim.cmd("startinsert")
end

local function close_floating_terminal()
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    vim.api.nvim_win_close(float_term_win, true)
    float_term_win = nil
  end
end

vim.keymap.set("n", "<C-n>", function()
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    close_floating_terminal()
  else
    create_floating_terminal()
  end
end, {
  desc = "Toggle floating terminal",
})

-- Also add escape key mapping for the floating terminal
vim.keymap.set("t", "<C-x>", function()
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    close_floating_terminal()
  end
end, {
  desc = "Close floating terminal from terminal mode",
})

-- Auto-resize floating terminal on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("FloatingTerminalResize", {
    clear = true,
  }),
  callback = function()
    if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      -- Ensure minimum dimensions
      width = math.max(width, 80)
      height = math.max(height, 20)

      -- Update window configuration with error handling
      local ok, err = pcall(vim.api.nvim_win_set_config, float_term_win, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
      })

      if not ok then
        vim.notify("Failed to resize floating terminal: " .. err, vim.log.levels.WARN)
      end
    end
  end,
})
