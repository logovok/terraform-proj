resource "aws_instance" "vprofile_db01" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  key_name = "tf-key-pair"
  associate_public_ip_address = true
  security_groups = ["${var.security_group_backend_services_id}"]
  user_data = "${file("./userdata/mysql.sh")}"
  tags = {
    Name = "vprofile_db01"
    Project = "vprofile"
  }
}

resource "aws_instance" "vprofile_mc01" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  key_name = "tf-key-pair"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.security_group_backend_services_id}"]
  user_data = "${file("./userdata/memcache.sh")}"
  tags = {
    Name = "vprofile_mc01"
    Project = "vprofile"
  }
}

resource "aws_instance" "vprofile_rmq01" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  key_name = "tf-key-pair"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.security_group_backend_services_id}"]
  user_data = "${file("./userdata/rabbitmq.sh")}"
  tags = {
    Name = "vprofile_rmq01"
    Project = "vprofile"
  }
}

resource "aws_instance" "vprofile_app01" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  key_name = "tf-key-pair"
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile

  vpc_security_group_ids = ["${var.security_group_tomcat_id}"]
  user_data = "${file("./userdata/tomcat_ubuntu.sh")}"
  tags = {
    Name = "vprofile_app01"
    Project = "vprofile"
  }
}
