return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
