locals {
  image_family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "ubuntu" {
  family = local.image_family
}

resource "yandex_vpc_network" "net" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.network_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_cidr]
}

resource "yandex_vpc_security_group" "sg" {
  name       = "kitty-sg"
  network_id = yandex_vpc_network.net.id

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port   = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "http gateway"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_address" "pub" {
  name = "kitty-ip"
  external_ipv4_address { zone_id = var.zone }
}

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.vm_platform
  zone        = var.zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_mem_gb
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_disk_gb
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
    nat_ip_address     = yandex_vpc_address.pub.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys  = "${var.vm_ssh_user}:${var.vm_ssh_pubkey}"
    user-data = templatefile("${path.module}/cloud-init.yaml", { vm_ssh_user = var.vm_ssh_user })
  }
}
