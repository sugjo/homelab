variable "argocd_version" {
  description = "Set ArgoCD version"
  type        = string
}

variable "root_path" {
  description = "Set root app path in git repo"
  type        = string
}

variable "root_repo" {
  description = "Set root app repo"
  type        = string
}

variable "hostname" {
  description = "hostname"
  type        = string
}