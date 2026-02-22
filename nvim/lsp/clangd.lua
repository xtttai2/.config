return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
  },

  filetypes = { 'cpp', 'cuda', 'c' },
}
