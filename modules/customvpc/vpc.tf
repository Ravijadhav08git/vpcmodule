locals {
  max_subnet_length = max(
    length(var.vpc_private_subnets),
    length(var.vpc_database_subnets),

  )
  nat_gateway_count = var.vpc_single_nat_gateway ? 1 : var.vpc_one_nat_gateway_per_az ? length(var.vpc_azs) : local.max_subnet_length

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc.vpc.*.id,
      [""],
    ),
    0,
  )
}


resource "aws_vpc" "vpc" {
  count = var.vpc_create ? 1 : 0
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.vpc_instance_tenancy
  enable_dns_hostnames             = var.vpc_enable_dns_hostnames
  enable_dns_support               = var.vpc_enable_dns_support

  assign_generated_ipv6_cidr_block = var.vpc_enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.vpc_tags_all,
    var.vpc_tags,
  )
}

# default sg
# Internet Gateway

resource "aws_internet_gateway" "igw" {
  count = var.vpc_create && var.vpc_create_igw && (length(var.vpc_public_subnets) > 0 || length(var.vpc_private_subnets) > 0 ) ? 1 : 0
  vpc_id = local.vpc_id
  tags = merge(
    {
      "Name" = format("%s-IGW", var.vpc_name)
    },
    var.vpc_tags_all,
    var.vpc_igw_tags,
  )
}

# Publiс routes

resource "aws_route_table" "public" {
  count = var.vpc_create && length(var.vpc_public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s-ROUTE_TABLE-${var.public_subnet_suffix}", var.vpc_name)
    },
    var.vpc_tags_all,
    var.vpc_public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.vpc_create && var.vpc_create_igw && length(var.vpc_public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = var.vpc_create && var.vpc_enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

# nat gate way
locals {
  nat_gateway_ips = split(
    ",",
    var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id),
  )
}

resource "aws_eip" "nat" {
  count = var.vpc_create && var.vpc_enable_nat_gateway && false == var.reuse_nat_ips ? local.nat_gateway_count : 0
  vpc = true
  tags = merge(
    {
      "Name" = format(
        "%s-EIP-%s",
        var.vpc_name,
        element(var.vpc_azs, var.vpc_single_nat_gateway ? 0 : count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_nat_eip_tags,
  )
}

resource "aws_nat_gateway" "ngw" {
  count = var.vpc_create && var.vpc_enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    local.nat_gateway_ips,
    var.vpc_single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    length(var.vpc_public_subnets) > 0 ? aws_subnet.public.*.id : aws_subnet.private.*.id ,
    var.vpc_single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "%s-NAT-%s",
        var.vpc_name,
        element(var.vpc_azs, var.vpc_single_nat_gateway ? 0 : count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.igw,aws_subnet.public,aws_subnet.private]
}

# private routes

resource "aws_route_table" "private" {
  count = var.vpc_create && local.max_subnet_length > 0 ? local.nat_gateway_count : 0
  vpc_id = local.vpc_id
  tags = merge(
    {
      "Name" = var.vpc_single_nat_gateway ? "${var.vpc_name}-${var.vpc_private_subnet_suffix}" : format(
        "%s-ROUTE_TABLE-${var.vpc_private_subnet_suffix}-%s",
        var.vpc_name,
        element(var.vpc_azs, count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_private_route_table_tags,
  )
}

# dbroutes
resource "aws_route_table" "database" {
  count = var.vpc_create && var.vpc_create_database_subnet_route_table && length(var.vpc_database_subnets) > 0 ? var.vpc_single_nat_gateway || var.vpc_create_database_internet_gateway_route ? 1 : length(var.vpc_database_subnets) : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.vpc_single_nat_gateway || var.vpc_create_database_internet_gateway_route ? "${var.vpc_name}-${var.vpc_database_subnet_suffix}" : format(
        "%s-ROUTE_TABLE-${var.vpc_database_subnet_suffix}-%s",
        var.vpc_name,
        element(var.vpc_azs, count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_database_route_table_tags,
  )
}


resource "aws_route" "database_internet_gateway" {
  count = var.vpc_create && var.vpc_create_igw && var.vpc_create_database_subnet_route_table && length(var.vpc_database_subnets) > 0 && var.vpc_create_database_internet_gateway_route && false == var.vpc_create_database_nat_gateway_route ? 1 : 0

  route_table_id         = aws_route_table.database[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}


resource "aws_route" "database_nat_gateway" {
  count = var.vpc_create && var.vpc_create_database_subnet_route_table && length(var.vpc_database_subnets) > 0 && false == var.vpc_create_database_internet_gateway_route && var.vpc_create_database_nat_gateway_route && var.vpc_enable_nat_gateway ? var.vpc_single_nat_gateway ? 1 : length(var.vpc_database_subnets) : 0

  route_table_id         = element(aws_route_table.database.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}


# Public subnet
resource "aws_subnet" "public" {
  count = var.vpc_create && length(var.vpc_public_subnets) > 0 && (false == var.vpc_one_nat_gateway_per_az || length(var.vpc_public_subnets) >= length(var.vpc_azs)) ? length(var.vpc_public_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = element(concat(var.vpc_public_subnets, [""]), count.index)
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) > 0 ? element(var.vpc_azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) == 0 ? element(var.vpc_azs, count.index) : null
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.public_subnet_assign_ipv6_address_on_creation
  ipv6_cidr_block = var.vpc_enable_ipv6 && length(var.public_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc[0].ipv6_cidr_block, 8, var.public_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-SUBNET-${var.public_subnet_suffix}-%s",
        var.vpc_name,
        element(var.vpc_azs, count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_public_subnet_tags,
  )
}

# Private subnet

resource "aws_subnet" "private" {
  count = var.vpc_create && length(var.vpc_private_subnets) > 0 ? length(var.vpc_private_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.vpc_private_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) > 0 ? element(var.vpc_azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) == 0 ? element(var.vpc_azs, count.index) : null
  assign_ipv6_address_on_creation = var.private_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.private_subnet_assign_ipv6_address_on_creation
  ipv6_cidr_block = var.vpc_enable_ipv6 && length(var.private_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc[0].ipv6_cidr_block, 8, var.private_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-SUBNET-${var.vpc_private_subnet_suffix}-%s",
        var.vpc_name,
        element(var.vpc_azs, count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_private_subnet_tags,
  )
}

# Database subnet

resource "aws_subnet" "database" {
  count = var.vpc_create && length(var.vpc_database_subnets) > 0 ? length(var.vpc_database_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.vpc_database_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) > 0 ? element(var.vpc_azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.vpc_azs, count.index))) == 0 ? element(var.vpc_azs, count.index) : null
  assign_ipv6_address_on_creation = var.database_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.database_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.vpc_enable_ipv6 && length(var.database_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc[0].ipv6_cidr_block, 8, var.database_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-SUBNET-${var.vpc_database_subnet_suffix}-%s",
        var.vpc_name,
        element(var.vpc_azs, count.index),
      )
    },
    var.vpc_tags_all,
    var.vpc_database_subnet_tags,
  )
}


resource "aws_db_subnet_group" "database" {
  count = var.vpc_create && length(var.vpc_database_subnets) > 0 && var.vpc_create_database_subnet_group ? 1 : 0
  name        = lower(var.vpc_name)
  description = "Database subnet group for ${var.vpc_name}"
  subnet_ids  = aws_subnet.database.*.id
  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.vpc_tags_all,
    var.vpc_database_subnet_group_tags,
  )
}
# Route table association

resource "aws_route_table_association" "private" {
  count = var.vpc_create && length(var.vpc_private_subnets) > 0 ? length(var.vpc_private_subnets) : 0
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.vpc_single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "database" {
  count = var.vpc_create && length(var.vpc_database_subnets) > 0 ? length(var.vpc_database_subnets) : 0

  subnet_id = element(aws_subnet.database.*.id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.database.*.id, aws_route_table.private.*.id),
    var.vpc_create_database_subnet_route_table ? var.vpc_single_nat_gateway || var.vpc_create_database_internet_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "public" {
  count = var.vpc_create && length(var.vpc_public_subnets) > 0 ? length(var.vpc_public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}
