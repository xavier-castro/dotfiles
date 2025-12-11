local opts = { noremap = true, silent = true }
function ToggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is " .. (vim.g.autoformat and "ON" or "OFF"))
end

function ExecuteCommand()
  vim.ui.input({
    prompt = "Command:",
    default = "",
    completion = 'command'
  }, function(input)
    if input then
      vim.cmd('terminal ' .. input)
    end
  end)
end

function ToggleQuickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
  else
    local win = vim.api.nvim_get_current_win()
    vim.cmd "copen"
    vim.api.nvim_set_current_win(win)
  end
end

---------------------------------
-- Normal mode mappings
-------------------------------
vim.api.nvim_set_keymap("n", "<leader>f", ":lua require('conform').format({})<CR>",
  { noremap = true, silent = true, desc = "Format Buffer" })
vim.api.nvim_set_keymap("n", "<leader>w", ":silent! w!<CR>", { noremap = true, silent = true, desc = "Save" })
vim.api.nvim_set_keymap("n", "<leader>h", ":noh<CR>", { noremap = true, silent = true, desc = "No highlight" })
vim.api.nvim_set_keymap("n", "<leader>o", ":Namu symbols<CR>", { noremap = false, silent = true, desc = "Find symbols" })
vim.api.nvim_set_keymap("n", "<leader>c", ":lua ExecuteCommand()<CR>",
  { noremap = false, silent = true, desc = "Run Command" })
vim.api.nvim_set_keymap('n', '<leader>t', ':lua ToggleQuickfix()<CR>',
  { noremap = true, silent = true, desc = "Toggle quickfix" })
vim.keymap.set("n", "<leader>lq", function()
  local win = vim.api.nvim_get_current_win()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
  vim.api.nvim_set_current_win(win)
end, { noremap = false, silent = true, desc = "Quick lsp fix" })
vim.api.nvim_set_keymap("n", "<C-n>", ":cn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":cp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>F",
  ":lua ToggleAutoformat()<CR>",
  { noremap = true, silent = true, desc = "Toggle autoformat" }
)

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Open External Programs
vim.keymap.set("n", "<M-o>", function()
  vim.cmd([[ silent !tmux new-window /usr/local/bin/opencode]])
end, { desc = "Open Opencode" })

vim.keymap.set("n", "<M-g>", function()
  vim.cmd([[ silent !tmux new-window /Users/xavier/.volta/bin/gemini]])
end, { desc = "Open Gemini" })

vim.keymap.set("n", "<M-c>", function()
  vim.cmd([[ silent !tmux new-window /Users/xavier/.volta/bin/claude  --dangerously-skip-permissions]])
end, { desc = "Open Claude CLI" })

---------------------------------
-- Visual mode mapping
---------------------------------

vim.api.nvim_set_keymap("v", "<Tab>", ">gv", opts)
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", opts)

require("scripts.floating-term")
