terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  version          = "${var.argocd_version}"
  values           = [file("${path.module}/values.yaml")]
}

resource "kubectl_manifest" "argocd_root" {
  yaml_body = templatefile("${path.module}/root.yaml", {
    path           = "${var.root_path}"
    repoURL        = "${var.root_repo}"
    targetRevision = "HEAD"
  })

  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "argocd_ingress" {
  yaml_body = templatefile("${path.module}/ingress.yaml", {
    hostname = "${var.hostname}"
  })

  depends_on = [helm_release.argocd]
}