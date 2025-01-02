return {
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach debugger to existing `node --inspect` process',
    processId = require('dap.utils').pick_process,
    sourceMaps = true,
    resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    cwd = '${workspaceFolder}/src',
    skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch (Node)',
    program = '${file}',
    cwd = '${workspaceFolder}',
    runtimeExecutable = 'npx',
    runtimeArgs = { 'tsx' },
  },
}
