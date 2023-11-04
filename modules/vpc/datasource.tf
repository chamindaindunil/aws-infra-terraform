data "aws_vpc" "main" {
  id = aws_vpc.main.id
}

locals {
  vpc_id = aws_vpc.main.id
}

data "aws_route_tables" "rt_private" {
  vpc_id = aws_vpc.main.id

  filter {
    name   = "tag:kubernetes.io/role/subnet"
    values = ["private"]
  }
}