return {
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    opts = {},
    keys = {
      {
        '<localleader>S',
        function()
          require('rip-substitute').sub()
        end,
        mode = { 'n', 'x' },
        desc = 'rip substitute',
      },
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = 'GrugFar',
  },
}
