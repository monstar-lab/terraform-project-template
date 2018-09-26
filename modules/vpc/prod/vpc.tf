###################################
# VPC
###################################
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidrs}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.env}-${var.project_name}-vpc"
    env  = "${var.env}"
  }
}

###################################
# Internet Gateway
###################################
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.env}-${var.project_name}-vpc-igw"
    env  = "${var.env}"
  }
}

###################################
# (Public) front subnet
###################################
resource "aws_subnet" "front" {
  count                   = "${length(var.front_subnet_cidrs)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.front_subnet_cidrs[count.index]}"
  availability_zone       = "${var.front_subnet_availability_zones[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name   = "${format("${var.env}-${var.project_name}-front-%02d", count.index + 1)}"
    env    = "${var.env}"
    subnet = "public"
  }
}

###################################
# (Private) app subnet
###################################
resource "aws_subnet" "app" {
  count             = "${length(var.app_subnet_cidrs)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.app_subnet_cidrs[count.index]}"
  availability_zone = "${var.app_subnet_availability_zones[count.index]}"

  tags {
    Name   = "${format("${var.env}-${var.project_name}-app-%02d", count.index + 1)}"
    env    = "${var.env}"
    subnet = "private"
  }
}

###################################
# (Private) datastore subnet
###################################
resource "aws_subnet" "datastore" {
  count             = "${length(var.datastore_subnet_cidrs)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.datastore_subnet_cidrs[count.index]}"
  availability_zone = "${var.datastore_subnet_availability_zones[count.index]}"

  tags {
    Name   = "${format("${var.env}-${var.project_name}-datastore-%02d", count.index + 1)}"
    env    = "${var.env}"
    subnet = "private"
  }
}

###################################
# (Private) batch subnet
###################################
resource "aws_subnet" "batch" {
  count             = "${length(var.batch_subnet_cidrs)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.batch_subnet_cidrs[count.index]}"
  availability_zone = "${var.batch_subnet_availability_zones[count.index]}"

  tags {
    Name   = "${format("${var.env}-${var.project_name}-datastore-%02d", count.index + 1)}"
    env    = "${var.env}"
    subnet = "private"
  }
}

###################################
# Route table
###################################
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-igw.id}"
  }

  tags {
    Name = "${var.env}-${var.project_name}-public-rt"
    env  = "${var.env}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.app_subnet_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.nat-gateway.*.id, count.index)}"
  }

  tags {
    Name = "${format("${var.env}-${var.project_name}-private-rt-%02d", count.index + 1)}"
    env  = "${var.env}"
  }
}

###################################
# Route table association
###################################
resource "aws_route_table_association" "front" {
  count          = "${length(var.front_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.front.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "app" {
  count          = "${length(var.app_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "datastore" {
  count          = "${length(var.datastore_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.datastore.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "batch" {
  count          = "${length(var.batch_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.batch.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

###################################
# NAT Gateway
###################################
resource "aws_nat_gateway" "nat-gateway" {
  count         = "${length(var.front_subnet_cidrs)}"
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.front.*.id, count.index)}"
}

###################################
# Elastic IP
###################################
resource "aws_eip" "eip" {
  count = "${length(var.front_subnet_cidrs)}"
  vpc   = true

  tags {
    env = "${var.env}"
  }
}

output "vpc" {
  value = "${
    map(
      "vpc_id",           "${aws_vpc.vpc.id}",
      "front-a",  "${element(aws_subnet.front.*.id, 0)}",
      "front-c",  "${element(aws_subnet.front.*.id, 1)}",
      "app-a",  "${element(aws_subnet.app.*.id, 0)}",
      "app-c",  "${element(aws_subnet.app.*.id, 1)}",
      "datastore-a",  "${element(aws_subnet.datastore.*.id, 0)}",
      "datastore-c",  "${element(aws_subnet.datastore.*.id, 1)}",
      "batch-a",  "${element(aws_subnet.batch.*.id, 0)}",
      "batch-c",  "${element(aws_subnet.batch.*.id, 1)}",
    )
  }"
}

output "app_subnet_list" {
  value = ["${aws_subnet.app.*.id}"]
}
