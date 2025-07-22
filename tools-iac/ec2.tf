resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAU7X7KNTFEFTSIR6F
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform, </h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    yor_trace            = "2c6ab514-a74e-4d41-b007-1c595404ec98"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.region}a"
  #encrypted         = false  # ssSetting this causes the volume to be recreated on apply 
  size = 1

  tags = {
    yor_trace            = "24e8af94-524d-421d-828f-03b44b65b0cd"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"

  tags = {
    yor_trace            = "35552eb3-963c-455f-996c-322d10332427"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  instance_id = "${aws_instance.web_host.id}"
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]
  tags = {
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
    yor_trace            = "b7af1b40-64eb-4519-a1a0-ab198db4b193"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge({
    Name = "${local.resource_prefix.value}-vpc"
    }, {
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
    yor_trace            = "9bf2359b-952e-4570-9595-52eba4c20473"
  })
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true


  tags = {
    yor_trace            = "805c793e-50ce-4f7b-b3be-e7a7af8d57ec"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true


  tags = {
    yor_trace            = "d6292a3f-9ba4-4e96-b292-f8eda0690170"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    yor_trace            = "c4c2a8b3-fc3c-4068-91db-d4ab14fc4b56"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    yor_trace            = "5f8716c5-a40f-4969-a38b-3ffb67ba9832"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}


resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
    yor_trace            = "9fb1df9b-802c-4843-bab8-e9f2fcf0b4c7"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id


  tags = {
    yor_trace            = "24fcc933-ffbf-440d-af55-2847c9d4d88d"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    yor_trace            = "851a02c1-7038-48d3-9cb6-f576341ee1b4"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/ec2.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}
