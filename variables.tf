variable "location" {
  description = "This is the cloud hosting region where your resource or app will be deployed."
}

variable "location_abv" {
  description = "This is the cloud hosting region where your resource or app will be deployed."
}

variable "enviroment" {
  description = "This is the environment where your webapp is deployed. uat, qa, prod, or dev"
}

variable "application" {
  description = "This is the name of the application"
}

variable "dns1" {
  description = "The DNS addresss 1"
}

variable "dns2" {
  description = "The DNS addresss 2"
}

variable "transitVnetCIDR" {
  description = "This is the CIDDR for the transit network"
}

variable "transitVnetAddressSpace" {
  description = "This is the Address space for for the transit network"
}

variable "subNetPrivate" {
  description = "This is the range for the Private network"
}


variable "WhiteListManagement" {
  type        = list(string)
  description = "This is the of addresses that should be able to reach the PA over the internet"

}

variable "tag_name" {
  description = "Name of the TAG"
  default     = "VIT-OWNER"
}
variable "tag_value" {
  description = "The tag Value"
  default     = "Roan PAes"
}
