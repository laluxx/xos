-- customize clangd by changing the flags below
local clangd_flags = {
    "--background-index",
    "--fallback-style=google",
    "--all-scopes-completion",
    "--clang-tidy",
    "--log=error",
    "--completion-style=detailed",
    "--pch-storage=disk",
    "--folding-ranges",
    "--enable-config",
    "--offset-encoding=utf-16",
  }
  
  local capabilities = require("lvim.lsp").common_capabilities()
  capabilities.offsetEncoding = { "utf-16" }
  
  require("lvim.lsp.manager").setup("clangd", {
    cmd = { "clangd", unpack(clangd_flags) },
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = capabilities,
  })
  
  -- install codelldb with :MasonInstall codelldb
  -- configure nvim-dap (codelldb)
  lvim.builtin.dap.on_config_done = function(dap)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        -- provide the absolute path for `codelldb` command if not using the one installed using `mason.nvim`
        command = "codelldb",
        args = { "--port", "${port}" },
  
        -- On windows you may have to uncomment this:
        -- detached = false,
      },
    }
  
    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  
    dap.configurations.c = dap.configurations.cpp
  end