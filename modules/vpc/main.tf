  cidr_block = var.vpc_cidrcat > modules/vpc/main.tf << 'EOF' resource "aws_vpc" "main" { enable_dns_hostnames = var.enable_dns_hostnames cidr_block = 
  var.vpc_cidr enable_dns_hostnames = var.enable_dns_hostnames enable_dns_support = var.enable_dns_support enable_dns_support = var.enable_dns_support tags = 
  merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-vpc" tags = merge(var.tags, { }) Name = "${var.project_name}-${var.environment}-vpc"}
  })
}resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id resource "aws_internet_gateway" "main" { vpc_id = aws_vpc.main.id tags = merge(var.tags, { Name = 
    "${var.project_name}-${var.environment}-igw"
  tags = merge(var.tags, { }) Name = "${var.project_name}-${var.environment}-igw"}
  })
}resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs) vpc_id = aws_vpc.main.id cidr_block = var.public_subnet_cidrs[count.index] availability_zone = 
  var.availability_zones[count.index] map_public_ip_on_launch = true
resource "aws_subnet" "public" { tags = merge(var.tags, { count = length(var.public_subnet_cidrs) Name = 
  "${var.project_name}-${var.environment}-public-${count.index + 1}" vpc_id = aws_vpc.main.id "kubernetes.io/role/elb" = "1" cidr_block = 
  var.public_subnet_cidrs[count.index] }) availability_zone = var.availability_zones[count.index]} map_public_ip_on_launch = true
resource "aws_subnet" "private" { count = length(var.private_subnet_cidrs) vpc_id = aws_vpc.main.id cidr_block = var.private_subnet_cidrs[count.index] 
  availability_zone = var.availability_zones[count.index] tags = merge(var.tags, { tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-${count.index + 1}" Name = "${var.project_name}-${var.environment}-private-${count.index + 1}" 
    "kubernetes.io/role/internal-elb" = "1" "kubernetes.io/role/elb" = "1" })
  })}
}
resource "aws_eip" "nat" { count = var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs) domain = "vpc"

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}" resource "aws_subnet" "private" { }) count = 
  length(var.private_subnet_cidrs)} vpc_id = aws_vpc.main.id cidr_block = var.private_subnet_cidrs[count.index]resource "aws_nat_gateway" "main" { count = 
  var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs) allocation_id = aws_eip.nat[count.index].id subnet_id = aws_subnet.public[count.index].id 
  availability_zone = var.availability_zones[count.index] tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-nat-${count.index + 1}" tags = merge(var.tags, { }) Name = 
    "${var.project_name}-${var.environment}-private-${count.index + 1}" "kubernetes.io/role/internal-elb" = "1" depends_on = [aws_internet_gateway.main]
  })}
}
resource "aws_route_table" "public" { vpc_id = aws_vpc.main.id

  route { cidr_block = "0.0.0.0/0" gateway_id = aws_internet_gateway.main.id resource "aws_eip" "nat" { } count = var.single_nat_gateway ? 1 : 
  length(var.public_subnet_cidrs) tags = merge(var.tags, { domain = "vpc" Name = "${var.project_name}-${var.environment}-public-rt"
  })
  tags = merge(var.tags, {} Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
  })resource "aws_route_table" "private" {
}  count = var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id resource "aws_nat_gateway" "main" { count = var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs) route { allocation_id = 
  aws_eip.nat[count.index].id cidr_block = "0.0.0.0/0" subnet_id = aws_subnet.public[count.index].id nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-private-rt-${count.index + 1}" tags = merge(var.tags, { }) Name = 
    "${var.project_name}-${var.environment}-nat-${count.index + 1}"}
  })
resource "aws_route_table_association" "public" { count = length(var.public_subnet_cidrs) subnet_id = aws_subnet.public[count.index].id route_table_id = 
  aws_route_table.public.id depends_on = [aws_internet_gateway.main]}
}
resource "aws_route_table_association" "private" { count = length(var.private_subnet_cidrs) subnet_id = aws_subnet.private[count.index].id route_table_id = 
  var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}
EOF resource "aws_route_table" "public" { vpc_id = aws_vpc.main.id route { cidr_block = "0.0.0.0/0" gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-public-rt"
  })
}
resource "aws_route_table" "private" { count = var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs) vpc_id = aws_vpc.main.id route { cidr_block = 
    "0.0.0.0/0" nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-private-rt-${count.index + 1}"
  })
}
resource "aws_route_table_association" "public" { count = length(var.public_subnet_cidrs) subnet_id = aws_subnet.public[count.index].id route_table_id = 
  aws_route_table.public.id
}
resource "aws_route_table_association" "private" { count = length(var.private_subnet_cidrs) subnet_id = aws_subnet.private[count.index].id route_table_id = 
  var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}
