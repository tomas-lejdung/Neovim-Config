return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'bash',
      'c',
      'go',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'sql',
      'typescript',
      'javascript',
      'php',
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'bash',
        'c',
        'go',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'sql',
        'typescript',
        'javascript',
        'php',
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
