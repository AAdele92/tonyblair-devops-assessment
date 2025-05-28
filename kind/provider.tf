terraform {
  required_version = "~>1.0"
  required_providers {
    kind = {
      source  = "kinvolk/kind"
      version = "~>0.1"
    }

 kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>3.0"
    }

  helm = {
      source = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Kubernetes provider to access the KinD cluster
provider "kubernetes" {
  host = kind_cluster.model_serving.endpoint

  client_certificate     = kind_cluster.model_serving.client_certificate
  client_key            = kind_cluster.model_serving.client_key
  cluster_ca_certificate = kind_cluster.model_serving.cluster_ca_certificate
}

# Helm provider to access the KinD cluster
provider "helm" {
  kubernetes {
    host = kind_cluster.model_serving.endpoint

    client_certificate     = kind_cluster.model_serving.client_certificate
    client_key            = kind_cluster.model_serving.client_key
    cluster_ca_certificate = kind_cluster.model_serving.cluster_ca_certificate
  }
}
provider "kind" {}