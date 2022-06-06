# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

provider "aws" {}


data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}


data "aws_vpc" "MyVPC" {
  tags = {
    Name = "MyVPC"
  }
}


resource "aws_subnet" "MyVPC_subnet_1" {
  vpc_id            = data.aws_vpc.MyVPC.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "MyVPC_subnet_2" {
  vpc_id            = data.aws_vpc.MyVPC.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}



output "MyVPC_id" {
  value = data.aws_vpc.MyVPC.id
}

output "MyVPC_cidr" {
  value = data.aws_vpc.MyVPC.cidr_block
}

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}


output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}


output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}
