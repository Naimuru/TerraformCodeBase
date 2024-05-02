variable "github_token" {
  type        = string
  description = "GitHub API token"
  sensitive   = true
  default     = ""
}
variable "github_username" {
  type        = string
  description = "GitHub username or organization name under which resources will be managed"
}

