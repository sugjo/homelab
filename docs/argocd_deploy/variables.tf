variable "cluster_context" {
  description = "Cluster context to deploy ArgoCD ROOT Application"
  type        = string
}

variable "hostname" {
  description = "ArgoCD ingress hostname"
  type        = string
}
