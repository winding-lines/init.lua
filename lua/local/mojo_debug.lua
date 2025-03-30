local M = {}

M.setup = function()
  local dap = require("dap")
  dap.adapters["mojo"] = {
    type = "executable",
    command = "mojo",
    args = { "test", "--vscode", "--stop-on-entry", "-I", "." },
    name = "mojo",
  }

  local mojo = {
    name = "Launch mojo test",
    type = "mojo", -- matches the adapter
    request = "launch", -- could also attach to a currently running process
    program = "${file}",
    cwd = "${workspaceFolder}",
  }

  dap.configurations.mojo = {
    mojo,
  }
end

return M
