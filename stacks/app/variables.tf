variable "owner" {
  description = "Ditt eget kortnavn. Går inn i alle ressursnavn."
  type        = string
}

variable "project_name" {
  description = "Prosjektnavn, del av navnegrunnlaget."
  type        = string
}

variable "environment" {
  description = "Miljønavn: dev eller test. Må være likt det network-stacken ble rullet ut med."
  type        = string

  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "environment må være dev eller test i denne obligen."
  }
}

variable "location" {
  description = "Azure-regionen ressursene opprettes i. Bør matche network-stacken."
  type        = string
  default     = "norwayeast"
}

variable "backend_resource_group_name" {
  description = "Ressursgruppa til backend-storage-kontoen (fra backend-bootstrap), brukt til å lese network-stackens remote state."
  type        = string
}

variable "backend_storage_account_name" {
  description = "Storage-kontoen state ligger i (fra backend-bootstrap)."
  type        = string
}

variable "backend_container_name" {
  description = "Containeren state ligger i."
  type        = string
  default     = "tfstate"
}

variable "network_state_key" {
  description = "Key til network-stackens state-fil for SAMME miljø, f.eks. env/dev/network.tfstate."
  type        = string
}

variable "data_subnet_key" {
  description = "Hvilket subnett (nøkkel i network-stackens subnet_ids-output) denne stacken skal koble seg til."
  type        = string
  default     = "data"
}
