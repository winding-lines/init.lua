--[[

Run an shell command asynchronously, parse the output as a Python/Mojo error stream and push in the quicklist.

--]]
--
-- Load the comand historian.
local historian = require("local/command_history")
historian.setup()

-- Load the error formats.
local efm = require("local/error_formats")

local M = {}

M.errorformat = efm.mojo .. "," .. efm.python

local function update_qlist(lines, bufnr, cmd, operation)
  vim.fn.setqflist({}, operation, {
    title = cmd,
    lines = lines,
    efm = M.errorformat,
  })
end

function M.make()
  local makeprg = historian.prompt_command(M._run)
end

function M._run(command)
  local winnr = vim.fn.win_getid()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  vim.notify("Running " .. command, vim.log.levels.INFO, {})

  update_qlist({ "Running: " .. command }, bufnr, command, "r")
  local cmd = vim.fn.expandcmd(command)

  local function on_event(_job_id, data, event) -- luacheck: ignore
    if event == "stdout" or event == "stderr" then
      if data then
        update_qlist(data, bufnr, cmd, "a")
      end
    end

    if event == "exit" then
      vim.api.nvim_command("doautocmd QuickFixCmdPost")
    end
  end

  local job_id = vim.fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

function M.setup()
  vim.api.nvim_create_user_command("MojoMake", M.make, {})
end

return M
