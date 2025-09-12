resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  namespace  = kubernetes_namespace.ns.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.18"
  values     = [file("${path.module}/values.yaml")]
}

resource "helm_release" "apps" {
  name      = "${var.release_name}-apps"
  namespace = kubernetes_namespace.ns.metadata[0].name
  chart     = "${path.module}/charts"
  values    = [templatefile("${path.module}/charts/values.yaml", {
    apps_repo_url  = var.apps_repo_url
    apps_repo_rev  = var.apps_repo_rev
    apps_repo_path = var.apps_repo_path
    app_name       = var.app_name
    app_namespace  = var.app_namespace
  })]
  depends_on = [helm_release.argocd]
}
