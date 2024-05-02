terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
    token  = var.github_token
    owner  = var.github_username
}

# Define a new GitHub Repository for codebase
resource "github_repository" "example_repo" {
  name        = "example"
  description = "My awesome codebase."
  visibility  = "public"
  auto_init   = true  # Ensure the repository is initialized with a default README.md
}

# Define a new GitHub Repository for web page
resource "github_repository" "webpage_repo" {
  name        = "webpage"
  description = "My awesome web page"
  visibility  = "public"
  auto_init   = true  # Ensure the repository is initialized with a default README.md
}

resource "null_resource" "initial_commit_example" {
  depends_on = [github_repository.example_repo] 

  provisioner "local-exec" {
    command = <<EOF
      cd "$(terraform workspace show)" 
      git clone https://github.com/${var.github_username}/example.git
      cd example
      echo "Initial commit" >> README.md
      git add README.md
      git commit -m "Placeholder commit for Terraform branching"
      git push origin main
    EOF
  }
}

# Define branches for example_repo
resource "github_branch" "development" {
  repository = github_repository.example_repo.name
  branch     = "development"
  depends_on = [null_resource.initial_commit_example]
}

resource "github_branch" "staging" {
  repository = github_repository.example_repo.name
  branch     = "staging"
  depends_on = [null_resource.initial_commit_example]
}

resource "github_branch" "production" {
  repository = github_repository.example_repo.name
  branch     = "production"
  depends_on = [null_resource.initial_commit_example]
}
