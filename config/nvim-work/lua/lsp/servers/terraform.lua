-- Terraform Language Server configuration
-- Supports Terraform LSP with validation

return {
  name = "terraform",
  servers = { "terraformls" },
  config = function()
    return {
      terraformls = {
        filetypes = { "terraform", "tf", "terraform-vars" },
        settings = {
          terraform = {
            validate = true,
          },
        },
      }
    }
  end,
}