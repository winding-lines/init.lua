-- Define python and mojo error formats.

M = {}

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

M.python = python_errorformat

-- Mojo error format courtesy of Claude.
M.mojo = "%f:%l:%c: %t%*[^:]: %m,%Z%*[^ ]^"
-- Generally less useful to parse the includes
-- M.mojo = M.mojo .. ",%+IIncluded from %f:%l:"

return M
