# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

# locals {
#   ubuntu_instances  = ["hadoop-master", "hadoop-worker1", "hadoop-worker2"]
#   fixed_ips = ["192.168.212.48", "192.168.212.65", "192.168.212.173"]
# }

variable "ubuntu_instances" {
  default  = {
    "hadoop-master" = "192.168.212.48" 
    "hadoop-worker1" = "192.168.212.65"
    "hadoop-worker2" = "192.168.212.173"
    }
}

resource "openstack_compute_instance_v2" "terratestU3" {
  
  # for_each   = toset(local.ubuntu_instances)
  for_each   = var.ubuntu_instances

  name = each.key
  flavor_id = "8c4dad4f-807d-4240-91e0-0fb958a1c671"
  key_pair = "Terraform_Ansible"
  stop_before_destroy = true
  force_delete = true

  security_groups = ["default"]

  network {
    name = "rrg-marios86-network"
    fixed_ip_v4 = each.value
  }

  block_device  {
    # uuid = "59671c16-03bd-4425-b86f-bd22ac58f343" # Old Ubuntu image
    uuid = "8986afe4-a907-4c78-b079-aff2c5a5bbe9"
    source_type = "image"
    destination_type = "volume"
    boot_index = 0
    volume_size = 40
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 80
    boot_index            = 1
    delete_on_termination = true
  }

  # provisioner “local-exec” {
  #     command = “ansible-playbook -u centos -i inventory /Users/v44ti/Documents/Ansible_Scripts/hadoop.yml”
  #  }
}