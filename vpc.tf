resource "aws_vpc" "bedrock_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "project-bedrock-vpc"
    Project = "barakat-2025-capstone"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.bedrock_vpc.id

  tags = {
    Name    = "project-bedrock-igw"
    Project = "barakat-2025-capstone"
  }
}


resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.bedrock_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "public-subnet-a"
    Project                  = "barakat-2025-capstone"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.bedrock_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "public-subnet-b"
    Project                  = "barakat-2025-capstone"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.bedrock_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name                              = "private-subnet-a"
    Project                           = "barakat-2025-capstone"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.bedrock_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "private-subnet-b"
    Project                           = "barakat-2025-capstone"
    "kubernetes.io/role/internal-elb" = "1"
  }
}


resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "project-bedrock-nat-eip"
    Project = "barakat-2025-capstone"
  }

  depends_on = [aws_internet_gateway.main]
}


resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name    = "project-bedrock-nat"
    Project = "barakat-2025-capstone"
  }

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bedrock_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "project-bedrock-public-rt"
    Project = "barakat-2025-capstone"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.bedrock_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name    = "project-bedrock-private-rt"
    Project = "barakat-2025-capstone"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}