// This is the same module block from 01-ssh-keypair. Terraform will know the
// old resource exists because of the state file it created. We will discuss
// that more later.
module "ssh_keys" {
  source = "../ssh_keys"
  name   = "terraform-tutorial"
}

// This is the same resource block from 02-single-instance.
resource "aws_instance" "web" {
  count = 3
  ami   = "${lookup(var.aws_amis, var.aws_region)}"

  instance_type = "t2.micro"
  key_name      = "${module.ssh_keys.key_name}"
  subnet_id     = "${aws_subnet.terraform-tutorial.id}"

  vpc_security_group_ids = ["${aws_security_group.terraform-tutorial.id}"]

  tags { Name = "web-${count.index}" }

  connection {
    user     = "ubuntu"
    key_file = "${module.ssh_keys.private_key_path}"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/scripts/wait-for-ready.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get --yes install apache2",
      "echo \"<h1>${self.public_dns}</h1>\" | sudo tee /var/www/html/index.html",
      "echo \"<h2>${self.public_ip}</h2>\"  | sudo tee -a /var/www/html/index.html",
    ]
  }

  // This installs an upstart script for the Consul agent.
  provisioner "file" {
    source      = "${path.module}/scripts/consul.conf"
    destination = "/tmp/consul.conf"
  }

  // This sets up the service.
  provisioner "file" {
    source      = "${path.module}/scripts/web.json"
    destination = "/tmp/web.json"
  }

  // This informs the Consul agent the address of the Consul server(s).
  provisioner "remote-exec" {
    inline = [
      "echo ${module.consul.address} > /tmp/consul-address",
    ]
  }

  // This installs Consul itself and starts the initial Consul process.
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/scripts/install-consul.sh"
    ]
  }
}

// This is the same resource block from 04-load-balancer.
resource "aws_elb" "web" {
  name = "web"

  subnets         = ["${aws_subnet.terraform-tutorial.id}"]
  security_groups = ["${aws_security_group.terraform-tutorial.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = ["${aws_instance.web.*.id}"]

  tags { Name = "terraform-tutorial" }
}

// This is the address of the ELB.
output "elb-address" { value = "${aws_elb.web.dns_name}" }
