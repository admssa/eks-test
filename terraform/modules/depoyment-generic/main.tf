resource "kubernetes_deployment" "this" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io" = var.name
      }
    }
    replicas = 1
    template {
      metadata {
        labels = {
          "app.kubernetes.io" = var.name
        }
      }
      spec {
        container {
          name = var.container_name
          image = var.container_image
          command = [
            "sleep",
            "99999"
          ]
        }
        service_account_name = var.sa_name
        automount_service_account_token = true
      }
    }
  }
  depends_on = [kubernetes_service_account.this]
}


resource "kubernetes_service_account" "this" {
  metadata {
    name = var.sa_name
    namespace = var.namespace
    annotations = {
       "eks.amazonaws.com/role-arn" = var.sa_role_arn
    }
  }
  automount_service_account_token = true
}