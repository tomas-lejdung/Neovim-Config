return {
  {
    'nvim-neotest/neotest',
    event = 'VeryLazy',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main', -- NOTE; not the master branch!
        build = function()
          vim.cmd ':TSUpdate go'
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        branch = 'fix/subtest-detection',
        dependencies = {
          {
            'leoluz/nvim-dap-go',
            'andythigpen/nvim-coverage',
          },
        },
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
        version = '*',
      },
      'marilari88/neotest-vitest',
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters['neotest-golang'] = {
        runner = 'gotestsum',
        testify_enabled = true,
        warn_test_name_dupes = false,
        go_test_args = {
          '-v',
          '-race',
          '-count=1',
          '-timeout=1200s',
          '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
        },
      }
      opts.adapters['neotest-vitest'] = {}
    end,
    config = function(_, opts)
      -- local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      -- vim.diagnostic.config({
      --   virtual_text = {
      --     format = function(diagnostic)
      --       -- Replace newline and tab characters with space for more compact diagnostics
      --       local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      --       return message
      --     end,
      --   },
      -- }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
      {
        '<leader>Tn',
        function()
          require('neotest').output_panel.clear()
          require('neotest').run.run()
        end,
        desc = '[t]est [n]earest',
      },
      {
        '<leader>Tl',
        function()
          require('neotest').output_panel.clear()
          require('neotest').run.run_last()
        end,
        desc = '[t]est [l]ast',
      },
      {
        '<leader>Tf',
        function()
          require('neotest').output_panel.clear()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[t]est run [f]ile',
      },
      {
        '<leader>TS',
        function()
          require('neotest').output_panel.clear()
          require('neotest').run.run { suite = true }
        end,
        desc = '[t]est [S]uite',
      },
      {
        '<leader>Tt',
        function()
          require('neotest').run.stop()
        end,
        desc = '[t]est [t]erminate',
      },
      {
        '<leader>Tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = '[t]est [w]atch file',
      },
      {
        '<leader>To',
        function()
          require('neotest').output.open { enter = true }
        end,
        desc = '[t]est [o]utput',
      },
      {
        '<leader>TO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[t]est [O]utput panel',
      },
      {
        '<leader>TC',
        function()
          require('neotest').output_panel.clear()
        end,
        desc = '[t]est [C]lear output panel',
      },
      {
        '<leader>Ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[t]est [s]ummary',
      },
      {
        '<leader>Td',
        function()
          require('neotest').run.run { strategy = 'dap', suite = false }
        end,
        desc = '[t]est [d]ebug nearest',
      },
    },
  },
}
