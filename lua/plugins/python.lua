return {
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      discovery = {
        filter_dir = function(name)
          return name ~= ".venv" and name ~= "venv" and name ~= "__pycache__" and name ~= ".git"
        end,
      },
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function(root)
            return root .. "/.venv/bin/python"
          end,
          args = { "-q" },
        },
      },
    },
  },
}
