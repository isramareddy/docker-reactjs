terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

resource "azuredevops_project" "project" {
  name       = "Terraform"
  description        = "AutomationTerraform"
}


resource "azuredevops_serviceendpoint_github" "example" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "GitHub Personal Access Token"

  auth_personal {
    personal_access_token = "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"
  }
}
resource "azuredevops_build_definition" "example" {
  project_id = azuredevops_project.project.id
  name       = "Project Build"
#   path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Baga114/docker-reactjs"
    branch_name           = "master"
    yml_path              = "azure-pipelines.yml"
    service_connection_id = azuredevops_serviceendpoint_github.example.id
  }

  schedules {
    branch_filter {
      include = ["main"]
      exclude = ["test", "regression"]
    }
  days_to_build              = ["Wed", "Sun"]
    schedule_only_with_changes = true
    start_hours                = 10
    start_minutes              = 59
    time_zone                  = "(UTC) Coordinated Universal Time"
  }
}
