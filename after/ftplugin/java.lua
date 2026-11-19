-- Função auxiliar para detetar o método Java sob o cursor via Treesitter
local function get_java_method_name()
  local ok, node = pcall(vim.treesitter.get_node)
  if ok and node then
    while node do
      if node:type() == "method_declaration" then
        for child in node:iter_children() do
          if child:type() == "identifier" then
            return vim.treesitter.get_node_text(child, 0)
          end
        end
      end
      node = node:parent()
    end
  end
  local word = vim.fn.expand("<cword>")
  return word ~= "" and word or nil
end

local function run(cmd)
  Snacks.terminal(cmd, {
    auto_close = false,
    interactive = true,
    win = { style = "terminal", position = "bottom", height = 15, border = "none" },
  })
end

-- 1. Correr MÉTODO de teste específico sob o cursor (Maven: ClassName#methodName)
vim.keymap.set("n", "<leader>tm", function()
  local class = vim.fn.expand("%:t:r")
  local method = get_java_method_name()
  if method then
    run("mvn test -Dtest=" .. class .. "#" .. method)
  else
    vim.ui.input({ prompt = "Método para testar em " .. class .. ": " }, function(input)
      if input and input ~= "" then
        run("mvn test -Dtest=" .. class .. "#" .. input)
      end
    end)
  end
end, { buffer = true, desc = "Run current Test Method via Maven" })

-- 2. Correr a CLASSE inteira com Maven (Maven: ClassName)
vim.keymap.set("n", "<leader>tc", function()
  run("mvn test -Dtest=" .. vim.fn.expand("%:t:r"))
end, { buffer = true, desc = "Run current Test Class via Maven" })

-- 3. Correr ficheiro de suite TestNG XML atual (Maven: -DsuiteXmlFile=...)
--vim.keymap.set("n", "<leader>tx", function()
-- local file = vim.fn.expand("%")
--  if file:match("%.xml$") then
--    run("mvn clean test -Dsuite.file=" .. file)
--  else
--    vim.notify("O ficheiro atual não é um XML!", vim.log.levels.WARN)
--  end
--end, { buffer = true, desc = "Run current TestNG XML Suite" })

-- 4. Correr MÉTODO de teste em debug específico sob o cursor (Maven: ClassName#methodName)
vim.keymap.set("n", "<leader>tM", function()
  local class = vim.fn.expand("%:t:r")
  local method = get_java_method_name()
  if method then
    run("mvnDebug test -Dtest=" .. class .. "#" .. method)
  else
    vim.ui.input({ prompt = "Método para debug em " .. class .. ": " }, function(input)
      if input and input ~= "" then
        run("mvnDebug test -Dtest=" .. class .. "#" .. input)
      end
    end)
  end
end, { buffer = true, desc = "Debug current Test Method via Maven" })

-- 5. Correr attach debugger
vim.keymap.set("n", "<leader>da", function()
  require("dap").continue()
end, { buffer = true, desc = "Attach Maven Debugger" })

-- JDTLS Test Methods execution keymap
vim.keymap.set("n", "<leader>jm", function()
  require("jdtls").test_nearest_method()
end, { buffer = true, desc = "JDTLS Test Method" })

-- JDTLS Test Class execution keymap
vim.keymap.set("n", "<leader>jc", function()
  require("jdtls").test_class()
end, { buffer = true, desc = "JDTLS Test Class" })
