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
    talos = {
      source = "siderolabs/talos"
      version = "0.7.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  load_config_file = true
}

# module "talos_init" {
#   source = "./talos"
# }

module "network" {
  source = "./network"
  cilium_version = "1.17.1"
  traefik_version = "34.3.0"
}

module "argocd" {
  source         = "./argocd"
  argocd_version = "7.8.2"
  root_path      = "apps"
  root_repo      = "git@github.com:sugjo/homelab.git"
  hostname       = "argocd.sugjo.local"
  depends_on = [ module.network ]
}

module "argoc_root_repo" {
  source     = "./argocd_repo"
  name       = "HomLab"
  repoURL    = "git@github.com:sugjo/homelab.git"
  ssh_key    = file("~/.ssh/ArgoCD")
  depends_on = [module.argocd]
}

module "argoc_example_repo" {
  source     = "./argocd_repo"
  name       = "example"
  repoURL    = "git@github.com:sugjo/argo-examples.git"
  ssh_key    = file("~/.ssh/Terraria")
  depends_on = [module.argocd]
}
