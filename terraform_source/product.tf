variable "product_data" {

  description = "data for product table"
  type = map(object({
    product_name = string
    product_description = string
  }))
}

variable "schema_for_product_table" {
  description = "Schema for product table"
  type = string
  default = "core"
}

resource "terraform_data" "product_table_data_resource" {
  for_each = var.product_data

  input = {
    product_code = each.key
    product_name = each.value.product_name
    product_description = each.value.product_description
  }
}