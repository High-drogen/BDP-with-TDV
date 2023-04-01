# your Kubernetes cluster name here
cluster_name = "k8s-cluster"

# # list of availability zones available in your OpenStack cluster
az_list = ["Compute"]
az_list_node = ["Compute"]

# # SSH key to use for access to nodes
public_key_path = "/Users/v44ti/.ssh/kubernetes-k8s-cluster.pub"

# # image to use for bastion, masters, standalone etcd instances, and nodes
image = "Ubuntu-20.04.3-Focal-x64-2021-12"

# # user on the node (ex. core on Container Linux, ubuntu on Ubuntu, etc.)
ssh_user = "ubuntu"

# # 0|1 bastion nodes
number_of_bastions = 1 # 1
bastion_fips = ["206.12.99.99"]
flavor_bastion = "22f7655d-45c1-4e01-83a0-2929e686f19b"

use_neutron  = 0

# # standalone etcds
number_of_etcd = 0
flavor_etcd = "22f7655d-45c1-4e01-83a0-2929e686f19b"

# masters
number_of_k8s_masters = 0
number_of_k8s_masters_no_etcd = 0
number_of_k8s_masters_no_floating_ip = 1
number_of_k8s_masters_no_floating_ip_no_etcd = 0
flavor_k8s_master = "14a6f9ff-4ab0-4df2-86e4-a66df670e6f2"

# master_allowed_ports = [{ "protocol" = "tcp", "port_range_min" = 20, "port_range_max" = 8081, "remote_ip_prefix" = "0.0.0.0/0"}]
# worker_allowed_ports = [{ "protocol" = "tcp", "port_range_min" = 20, "port_range_max" = 8081, "remote_ip_prefix" = "0.0.0.0/0"}]

# nodes
number_of_k8s_nodes = 0
number_of_k8s_nodes_no_floating_ip = 3 # 3 (before)
flavor_k8s_node = "e608c70c-a56b-47c9-9810-e06bf611eb04"

# #Commented out in favor of the gfs (below) section
# # GlusterFS
# # either 0 or more than one
# #number_of_gfs_nodes_no_floating_ip = 0
# #gfs_volume_size_in_gb = 150
# # Container Linux does not support GlusterFS
# image_gfs = "Ubuntu-20.04.3-Focal-x64-2021-12"
# # May be different from other nodes
# ssh_user_gfs = "ubuntu"
# flavor_gfs_node = "22f7655d-45c1-4e01-83a0-2929e686f19b"

# GlusterFS variables
flavor_gfs_node = "22f7655d-45c1-4e01-83a0-2929e686f19b"
image_gfs = "Ubuntu-20.04.3-Focal-x64-2021-12"
image_gfs_uuid = "8986afe4-a907-4c78-b079-aff2c5a5bbe9"
number_of_gfs_nodes_no_floating_ip = "0"
gfs_volume_size_in_gb = "50"
# ssh_user_gfs = "ubuntu"

# networking
network_name = "rrg-marios86-network"
external_net = "6621bf61-6094-4b24-a9a0-f5794c3a881e"

# subnet_cidr = "<cidr>"
# floatingip_pool = "Public-Network"
bastion_allowed_remote_ips = ["0.0.0.0/0"]

port_security_enabled = false

master_root_volume_size_in_gb = 20
node_root_volume_size_in_gb = 20