terraform{
  backend "s3" {
   bucket="table2hmterraform"
   key="terra/state"
   region="eu-west-1"
  }
}


provider "aws" {
  region = "eu-west-1"
}

provider "aws"{
  alias="us-east-1"
  region="us-east-1"
}

resource "aws_instance" "frontend-hm" {
  depends_on = ["aws_instance.backend-hm"]
  ami = "ami-08660f1c6fb6b01e7"
  instance_type = "t2.micro"
  key_name = "taco"
    tags = {
     Name = "table2hm-fe"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend-hm" {
  count = 1
  provider ="aws.us-east-1"
  ami = "ami-0565af6e282977273"
  instance_type = "t2.micro"
  key_name = "taco"
    tags = {
     Name = "table2hm-be"
  }
  timeouts {
    create = "60m"
    delete = "2h"
  }
}
