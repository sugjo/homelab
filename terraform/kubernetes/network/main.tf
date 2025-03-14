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

resource "helm_release" "cilium" {
  name             = "cilium"
  chart            = "cilium"
  repository       = "https://helm.cilium.io/"
  namespace = "kube-system"
  create_namespace = true
  version          = var.cilium_version
  values           = [file("${path.module}/cilium_values.yaml")]
}

resource "kubectl_manifest" "cilium_ippool" {
  yaml_body = templatefile("${path.module}/ippool.yaml", {

  })

  depends_on = [helm_release.cilium]
}

resource "kubectl_manifest" "cilium_l2_announcement" {
  yaml_body = templatefile("${path.module}/l2-announcement-policy.yaml", {

  })

  depends_on = [helm_release.cilium]
}

resource "helm_release" "traefik" {
  name             = "traefik"
  namespace        = "traefik"
  chart            = "traefik"
  repository       = "https://traefik.github.io/charts"
  create_namespace = true
  version          = var.traefik_version
  values           = [file("${path.module}/traefik_values.yaml")]
}
