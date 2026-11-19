local function run(cmd)
  Snacks.terminal(cmd, {
    auto_close = false,
    interactive = true,
    win = {
      style = "terminal",
      position = "bottom",
      height = 15,
      border = "none",
    },
  })
end

-- Correr a suite TestNG XML atual (o pom.xml usa a property ${suite.file})
vim.keymap.set("n", "<leader>tx", function()
  run("mvn clean test -Dsuite.file=" .. vim.fn.expand("%"))
end, { buffer = true, desc = "Run current TestNG XML Suite" })
