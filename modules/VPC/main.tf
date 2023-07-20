# Create VPC
resource "aws_vpc" "pbl" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames

  tags = merge(
    var.tags,
    {
      Name = "jmn_vpc"
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# Create public subnets
resource "aws_subnet" "public" {
  count = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  vpc_id = aws_vpc.pbl.id
  cidr_block = "10.0.${count.index + 20}.0/24"
  #cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "publicSubnet${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.pbl.id
  count      = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets
  cidr_block = "10.0.${count.index + 40}.0/24"
  #cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "privateSubnet${count.index + 1}"
  }
}