local M = {}

M.setup = function()
  local dap = require("dap")

  -- debug communication problems
  dap.set_log_level("TRACE")

  dap.adapters["mojo_run"] = {
    type = "server",
    port = "${port}",
    executable = {
      command = "mojo",
      args = { "debug", "--vscode", "--port", "${port}", "read_cats_and_dogs.mojo" },
    },
    name = "mojo_run",
    options = {
      initialize_timeout_sec = 20,
      detached = false,
    },
  }

  dap.configurations.mojo = {
    {
      name = "Launch mojo file",
      type = "mojo_run", -- matches the adapter
      request = "launch", -- could also attach to a currently running process
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
end

return M
