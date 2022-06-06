resource "ionoscloud_datacenter" "sysvdc" {
  name = var.system_vdc_name
  location = var.ionos_location
}

# The public LAN connecting the server to the internet
resource "ionoscloud_lan" "public-lan" {
  name          = "Public LAN"
  datacenter_id = ionoscloud_datacenter.sysvdc.id
  public        = true
}

# Public IP reserved for the server
resource "ionoscloud_ipblock" "public-ip" {
  name     = "Public IP"
  location = ionoscloud_datacenter.sysvdc.location
  size     = 1
}

resource "ionoscloud_server" "test-server" {
  name              = "Training Server"
  datacenter_id     = ionoscloud_datacenter.sysvdc.id
  availability_zone = "AUTO"
  cores             = 1
  ram               = 1024
  ssh_key_path      = [ "${var.test_id_rsa_pub}" ]
  image_name        = "Ubuntu-20.04-LTS-server-cloud-init"

  volume {
    name      = "Training Server Boot Volume"
    size      = 10
    disk_type = "HDD"
    user_data = base64encode(file("user-data.yaml"))
  }

  nic {
    lan             = ionoscloud_lan.public-lan.id
    dhcp            = true
    firewall_active = false
    ips             = ["${ionoscloud_ipblock.public-ip.ips[0]}"]
  }
}

output "public-ip-server" {
  value = ionoscloud_ipblock.public-ip.ips[0]
}

