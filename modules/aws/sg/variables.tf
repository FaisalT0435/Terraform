variable "name" { type = string }
variable "vpc_id" { type = string }
variable "ingress_rules" {
  description = "List of ingress rule objects"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}
variable "egress_rules" {
  description = "List of egress rule objects"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}
variable "tags" {
  type = map(string)
  default = {}
}
