return {
  name = "terraform",
  servers = { "terraformls", "tflint" },
  tools = { "terraform-ls", "tflint" },
  settings = {
    terraformls = {
      experimentalFeatures = {
        validateOnSave = true,
        prefillRequiredFields = true,
      },
      validation = {
        enableEnhancedValidation = true,
      },
    },
    tflint = {},
  },
  filetypes = { "terraform", "tf", "terraform-vars" },
}
