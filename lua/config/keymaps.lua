-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================================
-- TestNG / Java / Maven Test Keymaps
-- ============================================================================

-- 5. Keymap para DAP debug java
vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end, { desc = "DAP: Step Out" })

vim.keymap.set("n", "<leader>dd", function()
  require("dap").continue()
end, { desc = "Start/Attach Debug" })

-- ============================================================================
-- Gestão de Plugins (Lazy.nvim)
-- ============================================================================

-- Atualizar, sincronizar e carregar todos os plugins (<Espaço>pu)
vim.keymap.set("n", "<leader>pu", function()
  require("lazy").sync({ show = true })
end, { desc = "Plugins: Update & Sync (Lazy)" })

-- (Opcional) Recarregar as configurações do Neovim sem fechar o editor (<Espaço>pr)
vim.keymap.set("n", "<leader>pr", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Configurações do Neovim recarregadas!", vim.log.levels.INFO)
end, { desc = "Plugins: Reload Config" })

-- Carregar todos os plugins pendentes de uma só vez (<Espaço>pa ou <Espaço>pl)
vim.keymap.set("n", "<leader>pa", function()
  local config = require("lazy.core.config")
  local unloaded = {}

  -- Procura todos os plugins que ainda não foram carregados
  for name, plugin in pairs(config.plugins) do
    if not (plugin._ and plugin._.loaded) then
      table.insert(unloaded, name)
    end
  end

  if #unloaded > 0 then
    require("lazy").load({ plugins = unloaded })
    vim.notify("Foram carregados " .. #unloaded .. " plugins com sucesso!", vim.log.levels.INFO, { title = "Lazy" })
  else
    vim.notify("Todos os plugins já se encontram carregados!", vim.log.levels.INFO, { title = "Lazy" })
  end
end, { desc = "Plugins: Load All" })

vim.api.nvim_create_user_command("LazyLoadAll", function()
  local start = vim.loop.hrtime()

  local Config = require("lazy.core.config")

  local count = 0

  for name, _ in pairs(Config.plugins) do
    require("lazy").load({ plugins = { name } })
    count = count + 1
  end

  local elapsed = (vim.loop.hrtime() - start) / 1000000

  vim.notify(string.format("✅ %d plugins carregados em %.0f ms", count, elapsed), vim.log.levels.INFO, {
    title = "Lazy.nvim",
    timeout = 3000,
  })
end, {})

vim.keymap.set("n", "<leader>LA", "<cmd>LazyLoadAll<CR>", {
  desc = "Load all lazy plugins",
})
