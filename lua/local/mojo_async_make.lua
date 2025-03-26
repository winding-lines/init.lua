--[[

Run an shell command asynchronously, parse the output as a Mojo error stream and push in the quicklist.

--]]
--
-- Load the comand historian.
local historian = require("local/command_history")
historian.setup()

local M = {}

-- Python error format.
-- Use each file and line of Tracebacks (to see and step through the code executing)
local python_errorformat = '%A%\\s%#File "%f"\\, line %l\\, in%.%#'

-- Include failed toplevel doctest example
python_errorformat = python_errorformat .. ",%+CFailed example:%.%#"

-- Ignore big star lines from doctests
python_errorformat = python_errorformat .. ",%-G*%\\{70%\\}"

-- Ignore most of doctest summary
python_errorformat = python_errorformat .. ",%-G%*\\d items had failures:"
python_errorformat = python_errorformat .. ",%-G%*\\s%*\\d of%*\\s%*\\d in%.%#"

-- SyntaxErrors (%p is for the pointer to the error column)
python_errorformat = python_errorformat .. ',%E  File "%f"\\, line %l'

-- %p must come before other lines that might match leading whitespace
python_errorformat = python_errorformat .. ",%-C%p^"
python_errorformat = python_errorformat .. ",%+C  %m"
python_errorformat = python_errorformat .. ",%Z  %m"

-- Error format courtesy of Claude.
local mojo_errorformat = "%f:%l:%c: %t%*[^:]: %m,%Z%*[^ ]^,%+IIncluded from %f:%l:"
M.errorformat = mojo_errorformat .. "," .. python_errorformat

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
