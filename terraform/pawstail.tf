variable "private_key_path" {
      description = "path to ssh private key"
}

variable "access_key" {
      description = "AWS access key"
}
variable "secret_key" {
      description = "AWS secret key"
}

provider "aws" {
    region     = "us-west-2"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_security_group" "ssh_server" {
  name = "ssh_server"
  description = "allow 22 inbound"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 443
      to_port = 443
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
      from_port = 80
      to_port = 80
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
      from_port = 6660 
      to_port = 6669
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "main" {
        cidr_block = "10.0.0.0/16"
        enable_dns_support = true
}

resource "aws_subnet" "main" {
        vpc_id = "${aws_vpc.main.id}"
        map_public_ip_on_launch = true
        cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "main"
    }
}

resource "aws_route_table_association" "a" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "main"
    }
}

resource "aws_instance" "IRC_box" {
    ami = "ami-9abea4fb"
    vpc_security_group_ids = ["${aws_security_group.ssh_server.id}"]
    instance_type = "t2.nano"
    key_name = "ziege.public"
    subnet_id = "${aws_subnet.main.id}"
    provisioner "remote-exec" {
        inline = ["ls"]
    connection {
      type = "ssh"
      user = "ubuntu"
#      private_key = "${file(var.private_key_path)}"
     }

      }
    provisioner "local-exec" {
        command = "ANSIBLE_HOST=${aws_instance.IRC_box.public_ip} ANSIBLE_GROUPS=remote_workstation ansible-playbook ansible/site.yml --tags untagged -vv -i ansible/dynamic.py --vault-password-file /home/terminal/.vault_pass.txt"
	}
}
