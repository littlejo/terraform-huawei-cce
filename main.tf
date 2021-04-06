data "huaweicloud_availability_zones" "myaz" {}

resource "huaweicloud_cce_cluster" "this" {
  name                   = var.name
  flavor_id              = var.cluster_flavor
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  multi_az               = true
  container_network_type = "overlay_l2"
}

resource "huaweicloud_cce_node_pool" "this" {
  count                    = 3
  cluster_id               = huaweicloud_cce_cluster.this.id
  name                     = var.name_node_pool
  os                       = "EulerOS 2.5"
  initial_node_count       = 1
  flavor_id                = var.flavor
  availability_zone        = data.huaweicloud_availability_zones.myaz.names[count.index]
  key_pair                 = var.public_key_name
  scall_enable             = true
  min_node_count           = 1
  max_node_count           = 5
  scale_down_cooldown_time = 100
  priority                 = 1
  type                     = "vm"

  root_volume {
    size       = 40
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
}

resource "huaweicloud_cce_addon" "this" {
    cluster_id    = huaweicloud_cce_cluster.this.id
    template_name = "metrics-server"
    version       = "1.0.5"
}

# TODO
#resource "huaweicloud_cce_addon" "autoscaler" {
#    cluster_id    = huaweicloud_cce_cluster.this.id
#    template_name = "autoscaler"
#    version       = "1.17.8"
#}
