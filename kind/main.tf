resource "kind_cluster" "default" {
    name            = var.cluster_name
    kind_version    = var.kind_version
    node_image      = var.node_image
    kubeconfig_path = pathexpand("/tmp/config")
    wait_for_ready  = true

    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"

        # Port mappings for local access
        extra_port_mappings {
          container_port = 30000 # App
          host_port      = 8000
        }

        # Prometheus
        extra_port_mappings {
          container_port = 30001 
          host_port      = 9090
        }

        # Grafana
        extra_port_mappings {
          container_port = 30002 
          host_port      = 3000
        }

        # PostgreSQL
        extra_port_mappings {
          container_port = 30003 
          host_port      = 5432
        }
      } # <-- closes control-plane node

      node {
          role = "worker"
      }
    } # <-- closes kind_config
} # <-- closes kind_cluster

# Install Metrics Server
resource "null_resource" "install_metrics_server" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }

  depends_on = [kind_cluster.model_serving]
}

# Install Monitoring Stack (Prometheus + Grafana)
resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "prometheus.service.type"
    value = "NodePort"
  }

  set {
    name  = "prometheus.service.nodePort"
    value = "30001"
  }

  set {
    name  = "grafana.service.type"
    value = "NodePort"
  }

  set {
    name  = "grafana.service.nodePort"
    value = "30002"
  }

  set {
    name  = "grafana.adminPassword"
    value = "admin"
  }

  depends_on = [kind_cluster.model_serving]
}

# Install PostgreSQL
resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = "model-serving"
  create_namespace = true

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.nodePort"
    value = "30003"
  }

  set {
    name  = "auth.postgresPassword"
    value = "password"
  }

  set {
    name  = "auth.database"
    value = "modelmetadata"
  }

  depends_on = [kind_cluster.model_serving]
}

# Create namespace for our application
resource "kubernetes_namespace" "model_serving" {
  metadata {
    name = "model-serving"
  }

  depends_on = [kind_cluster.model_serving]
}