return {
  "ywpkwon/yank-path.nvim",
  config = function()
    require("yank-path").setup({
      default_mapping = true,
      use_oil = true, -- enable built-in Oil.nvim integration
    })
  end,
}
