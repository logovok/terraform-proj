resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public subnet"
  }
}


resource "aws_subnet" "empty_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  
  availability_zone = "us-east-1b"

  tags = {
    Name = "Empty subnet"
  }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "terraform_public_rtb"
    Tier = "public"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public-rtb.id
  subnet_id = aws_subnet.public.id
}

output "subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.empty_subnet.id]
}