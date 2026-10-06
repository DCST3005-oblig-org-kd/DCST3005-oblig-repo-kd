variable "owner" {
  description = "Ditt eget kortnavn. Går inn i alle ressursnavn."
  type        = string
}

variable "project_name" {
  description = "Prosjektnavn, del av navnegrunnlaget."
  type        = string
}

variable "environment" {
  description = "Miljønavn: dev eller test. Kommer inn som en VERDI fra pipelinen, ikke som et mappenavn (K4)."
  type        = string

  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "environment må være dev eller test i denne obligen."
  }
}

variable "location" {
  description = "Azure-regionen ressursene opprettes i."
  type        = string
  default     = "norwayeast"
}

variable "vnet_cidr" {
  description = "Adresserommet dette miljøet disponerer, som CIDR."
  type        = string
}

variable "subnets" {
  description = "Subnett som skal opprettes: navn => netnum innenfor adresserommet. Må inneholde 'data', som app-stacken kobler seg til."
  type        = map(number)

  validation {
    condition     = contains(keys(var.subnets), "data")
    error_message = "subnets må inneholde en oppføring kalt 'data' - app-stacken henter nettopp den via terraform_remote_state."
  }
}
