output "kubeconfig" {
  value = huaweicloud_cce_cluster.this.kube_config_raw
}

output "url" {
  value = huaweicloud_cce_cluster.this.internal
}


output "cluster_name" {
  value = huaweicloud_cce_cluster.this.certificate_clusters/name
}
