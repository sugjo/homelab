provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.cluster_context
}

resource "kubernetes_manifest" "argocd_root" {
  manifest = yamldecode(templatefile("${path.module}/ingress.yaml", {
    hostname = var.hostname
  }))
}

resource "helm_release" "argocd_release" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.8.2"
  values           = [file("${path.module}/values.yaml")]
}
