output "name" {
  value = kubernetes_deployment.this.metadata.*.name
}