data "aws_availability_zones" "available" {}


locals {
  vpc_tags = merge(
    var.common_tags,
    var.eks_tags,
  )
  nat_gw_count = var.single_nat_gw ? 1 : length(var.public_subnets_prefixes)
}


data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_prefixes)
  cidr_block        = element(var.private_subnets_prefixes, count.index)
  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.common_tags,
    map(
      "Name", "EKS-private-${var.cluster_name}-${data.aws_availability_zones.available.names[count.index]}"
    ),
    var.eks_tags
  )
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets_prefixes)
  cidr_block        = element(var.public_subnets_prefixes, count.index)
  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.common_tags,
    map(
      "Name", "EKS-public-${var.cluster_name}-${data.aws_availability_zones.available.names[count.index]}"
    ),
    var.eks_tags
  )
}

resource "aws_eip" "nat_ips" {
  count = local.nat_gw_count
  vpc   = true

  tags = merge(
    var.common_tags,
    map(
      "Name", "EKS-NAT-${var.cluster_name}-${element(aws_subnet.public_subnets.*.availability_zone, count.index)}"
    )
  )
}

resource "aws_nat_gateway" "nat_gws" {
  count         = local.nat_gw_count
  allocation_id = element(aws_eip.nat_ips.*.id, var.single_nat_gw ? 0 : count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, var.single_nat_gw ? 0 : count.index)

  tags = merge(
    var.common_tags,
    map(
      "Name", "EKS-NAT-${var.cluster_name}-${element(aws_subnet.public_subnets.*.availability_zone, count.index)}"
    ),
    var.eks_tags
  )
}

resource "aws_route_table" "private_route_tables" {
  count  = length(var.private_subnets_prefixes)
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    map(
      "Name", "EKS-RT-${var.cluster_name}-private-${element(aws_subnet.private_subnets.*.availability_zone, count.index)}"
    ),
    var.eks_tags
  )
}

resource "aws_route" "private_routes" {
  count          = length(var.private_subnets_prefixes)
  route_table_id = element(aws_route_table.private_route_tables.*.id, count.index)

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gws.*.id, var.single_nat_gw ? 0 : count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    map("Name", "EKS-RT-${var.cluster_name}-public")
  )
}

resource "aws_route" "default_gw_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnets_prefixes)
  route_table_id = element(aws_route_table.private_route_tables.*.id, count.index)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnets_prefixes)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}

