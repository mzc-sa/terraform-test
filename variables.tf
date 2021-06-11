#################
# Security group
#################
variable "name" {
  description = "Name of security group - not required if create_group is false"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

# variable "ingress_with_source_security_group_id" {
#   description = "List of ingress rules to create where 'source_security_group_id' is used"
#   type        = list(map(string))
#   default     = []
# }

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}


#########
# Egress
#########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

# variable "egress_cidr_blocks" {
#   description = "List of IPv4 CIDR ranges to use on all egress rules"
#   type        = list(string)
#   default     = ["0.0.0.0/0"]
# }
