variable "working_dir" {
  description = "working directory for the code"
  type = string
}


resource "terraform_data" "write_product_table_records" {
  for_each = terraform_data.product_table_data_resource

  input = {
    working_dir = var.working_dir
    product_code = terraform_data.product_table_data_resource[each.key].input.product_code
    product_name = terraform_data.product_table_data_resource[each.key].input.product_name
    product_description = terraform_data.product_table_data_resource[each.key].input.product_description
    schema = var.schema_for_product_table
  }

  triggers_replace = [
  terraform_data.product_table_data_resource[each.key].input.product_code,
  terraform_data.product_table_data_resource[each.key].input.product_name,
  terraform_data.product_table_data_resource[each.key].input.product_description
  ]

  depends_on = [terraform_data.product_table_data_resource]

  provisioner "local-exec" {
    working_dir = self.input.working_dir

    command = "python3 scripts/manage_product.py \"${self.input.schema}\" \"product\" \"N\" \"${self.input.product_code}\" \"${self.input.product_name}\" \"${self.input.product_description}\""
  }

  provisioner "local-exec" {
    when = destroy
    working_dir = self.input.working_dir

    command = "python3 scripts/manage_product.py \"${self.input.schema}\" \"product\" \"Y\" \"${self.input.product_code}\" \"${self.input.product_name}\" \"${self.input.product_description}\""

  }
}