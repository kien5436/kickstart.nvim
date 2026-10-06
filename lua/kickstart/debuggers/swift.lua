-- Swift debugger configurations for nvim-dap (lldb-dap from Swift toolchain).
-- Loaded by `lua/kickstart/plugins/debugger.lua` via `kickstart.debuggers.swift`.
-- Requires `lldb-dap` on PATH (ships with Swift, e.g. via swiftly).

local function package_root()
  local path = vim.fn.expand '%:p:h'
  local found = vim.fs.find('Package.swift', { upward = true, path = path })[1]
  if found then
    return vim.fn.fnamemodify(found, ':h')
  end
  return vim.fn.getcwd()
end

-- Executable target names from the manifest. The binary is the *target*
-- name, which often differs from the folder name (`my-proj` -> `my_proj`).
local function manifest_target_names(root)
  local f = io.open(root .. '/Package.swift', 'r')
  if not f then
    return {}
  end
  local src = f:read '*a'
  f:close()
  local names = {}
  for name in src:gmatch '%.executableTarget%s*%(%s*name%s*:%s*"([^"]+)"' do
    names[#names + 1] = name
  end
  return names
end

-- Built executables in `.build/debug/`: extensionless executable files.
local function built_executables(root)
  local build_dir = root .. '/.build/debug'
  if vim.fn.isdirectory(build_dir) ~= 1 then
    return {}
  end
  local found = {}
  for _, path in ipairs(vim.fn.glob(build_dir .. '/*', false, true)) do
    if vim.fn.isdirectory(path) ~= 1 and vim.fn.executable(path) == 1 and not vim.fn.fnamemodify(path, ':t'):find('%.', 1, true) then
      found[#found + 1] = path
    end
  end
  return found
end

-- Rebuild before every launch so the binary matches the current sources.
-- A failed build aborts the launch with the compiler output.
local function ensure_built(root)
  if vim.fn.executable 'swift' ~= 1 then
    return
  end
  vim.notify('Swift: building…', vim.log.levels.INFO)
  local result = vim.system({ 'swift', 'build' }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    error('Swift build failed:\n' .. (result.stderr ~= '' and result.stderr or result.stdout), 0)
  end
end

local function resolve_program()
  local root = package_root()
  if vim.fn.filereadable(root .. '/Package.swift') == 1 then
    ensure_built(root)
  end
  local build_dir = root .. '/.build/debug'
  -- 1. Manifest target names that are actually built.
  for _, name in ipairs(manifest_target_names(root)) do
    local path = build_dir .. '/' .. name
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  -- 2. Whatever executable was actually built.
  local candidates = built_executables(root)
  if #candidates == 1 then
    return candidates[1]
  end
  if #candidates > 1 then
    -- Prefer the one matching the folder (hyphens/underscores normalized).
    local want = vim.fn.fnamemodify(root, ':t'):gsub('-', '_')
    for _, path in ipairs(candidates) do
      if vim.fn.fnamemodify(path, ':t'):gsub('-', '_') == want then
        return path
      end
    end
    table.sort(candidates)
    return vim.fn.input('Executable (multiple built): ', candidates[1], 'file')
  end
  -- 3. Nothing built: fail fast with an actionable message instead of
  -- handing lldb-dap a bogus path.
  error('Swift: no built executable in ' .. build_dir .. ' — run `swift build` first', 0)
end

-- Compile the current buffer with `swiftc -g` on every launch, so a lone
-- `.swift` file (no Package.swift) can be debugged. Returns the binary path.
local function compile_current_file()
  local src = vim.fn.expand '%:p'
  if vim.fn.filereadable(src) ~= 1 then
    error('Swift: no file to compile (save the buffer first)', 0)
  end
  if vim.fn.executable 'swiftc' ~= 1 then
    error('Swift: swiftc not found on PATH', 0)
  end
  local outdir = vim.fn.stdpath 'cache' .. '/swift-debug'
  vim.fn.mkdir(outdir, 'p')
  local out = outdir .. '/' .. vim.fn.fnamemodify(src, ':t:r')
  vim.notify('Swift: compiling ' .. vim.fn.fnamemodify(src, ':t') .. '…', vim.log.levels.INFO)
  local result = vim.system({ 'swiftc', '-g', '-o', out, src }, { text = true }):wait()
  if result.code ~= 0 then
    error('Swift compile failed:\n' .. (result.stderr ~= '' and result.stderr or result.stdout), 0)
  end
  return out
end

return {
  {
    type = 'lldb-dap',
    request = 'launch',
    name = 'SwiftPM: Launch executable',
    program = resolve_program,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    type = 'lldb-dap',
    request = 'launch',
    name = 'Swift: Launch (prompt for executable)',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    type = 'lldb-dap',
    request = 'launch',
    name = 'Swift: Current file (compile with swiftc)',
    program = compile_current_file,
    cwd = '${fileDirname}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}
