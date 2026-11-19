require("dap").configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Attach to Maven Debug",
    hostName = "127.0.0.1",
    port = 8000,
  },
}
