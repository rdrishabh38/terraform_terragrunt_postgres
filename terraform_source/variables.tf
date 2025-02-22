variable "env_vars" {
  description = "Map of database connection parameters read from bash environment"
  type        = map(string)
  default     = {}
}
