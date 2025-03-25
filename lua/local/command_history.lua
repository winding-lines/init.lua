--[[
-- Command History Plugin for Neovim.
-- Writtan by claude.ai and adapted.
--]]

local M = {}

-- Configuration
local config = {
  history_file = vim.fn.stdpath("data") .. "/command_history.json",
  max_history = 100, -- Maximum number of commands to remember
}

-- Command history storage
M.history = {}

-- Load command history from file
local function load_history()
  local file = io.open(config.history_file, "r")
  if file then
    local content = file:read("*all")
    file:close()
    if content and content ~= "" then
      local ok, data = pcall(vim.fn.json_decode, content)
      if ok and type(data) == "table" then
        M.history = data
      end
    end
  end
end

-- Save command history to file
local function save_history()
  local file = io.open(config.history_file, "w")
  if file then
    local content = vim.fn.json_encode(M.history)
    file:write(content)
    file:close()
  end
end

-- Add a command to history
local function add_to_history(cmd)
  -- Don't add empty commands
  if not cmd or cmd == "" then
    return
  end

  -- Remove the command if it already exists (to avoid duplicates)
  for i, item in ipairs(M.history) do
    if item == cmd then
      table.remove(M.history, i)
      break
    end
  end

  -- Add the command to the beginning of the history
  table.insert(M.history, 1, cmd)

  -- Trim the history if it exceeds the maximum length
  while #M.history > config.max_history do
    table.remove(M.history)
  end

  -- Save the updated history
  save_history()
end

-- Prompt for a command with history support
-- The `on_confirm` function will be called with the user's selection.
function M.prompt_command(on_confirm)
  -- Load history if not already loaded
  if #M.history == 0 then
    load_history()
  end

  if #M.history == 0 then
    -- If no history, set a default command
    M.history = { "magic run test" }
  end

  -- Create the input prompt
  local input_opts = {
    prompt = "Async Mojo Command",
    history = M.history,
    completion = "command",
    default = M.history[1],
  }

  vim.ui.input(input_opts, function(cmd)
    if cmd then
      add_to_history(cmd)
      on_confirm(cmd)
    end
  end)
end

-- Create a command to access the command history prompt
function M.setup()
  vim.api.nvim_create_user_command("CommandHistory", function()
    M.prompt_command()
  end, {})

  -- Load history on startup
  load_history()
end

return M
