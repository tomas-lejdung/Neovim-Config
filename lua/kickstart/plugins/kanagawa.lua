return {
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    enabled = true,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        theme = 'wave',
        dimInactive = true,
      }
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
