terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "argocd_homelab_repo" {
  sensitive_fields = [
    "stringData.sshPrivateKey",
    "stringData.url"
  ]

  yaml_body = templatefile("${path.module}/repo_secret.yaml", {
    name       = "${var.name}"
    name_lower = "${lower(var.name)}"
    repoURL    = "${var.repoURL}"
    ssh_key    = split("\n", var.ssh_key)
  })
}
