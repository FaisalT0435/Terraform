variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "key_name" { type = string }
variable "security_group_ids" { type = list(string) }
variable "instance_count" { 
    type = number 
    default = 1 
}
    
variable "tags" { 
    type = map(string) 
    default = {} 
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "ec2"
}
variable "public_key_path" {
  description = "Local path to public key"
  type        = string
  default     = "./keypair.pub"
}

