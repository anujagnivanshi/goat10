# To initialize module
provider "aws" {

  region     = "us-east-2"
  
}
module "ext_vm" {
  source       = "./ec2"
  image_id     = "ami-0fc20dd1da406780b"
  iam_role     = "${module.access_mgmt.profile_iam}"
  subnet       = "${module.network.vlan-pub}"
  keypair_name = "awstestkey"
  sec_group    = "${module.network.sg-link-pub}"
  ebs_size     = "12"
  ebs_type     = "standard"
  machine_type = "t2.micro"
}
module "int_vm" {
  source       = "./ec2"
  image_id     = "ami-0fc20dd1da406780b"
  iam_role     = "${module.access_mgmt.profile_iam}"
  subnet       = "${module.network.vlan-pri}"
  keypair_name = "awstestkey"
  sec_group    = "${module.network.sg-link-pri}"
  ebs_size     = "12"
  ebs_type     = "standard"
  machine_type = "t2.micro"
}


module "network" {
  source    = "./vpc"
  vpc_range = "192.168.16.0/24"
  pub_range = "192.168.16.0/28"
  pri_range = "192.168.16.16/28"
  local_ip  = "0.0.0.0/0"
}

module "access_mgmt" {
  source  = "./iam"
  env     = "dev"
  service = "s3"
}
