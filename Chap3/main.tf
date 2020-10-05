provider "aws" {    
  region = "us-east-2" 
}

module "webserver" {
  source = "./webserver"    
}

module "db" {
  source = "./db"
}