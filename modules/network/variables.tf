variable "rg_name" {
  description = "Ressursgruppa modulen opprettes i. Leveres av stacken, opprettes ikke her."
  type        = string
}

variable "location" {
  description = "Azure-regionen ressursene opprettes i."
  type        = string
}

variable "base_name" {
  description = "Navnegrunnlag levert av stacken, f.eks. 'oblig1-dev-kd'. Modulen setter selv på prefiksene vnet-, snet- og nsg-."
  type        = string
}

variable "vnet_cidr" {
  description = "Adresserommet vnet-et disponerer, som CIDR, f.eks. 10.10.0.0/16."
  type        = string

  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "vnet_cidr må være en gyldig CIDR-blokk, f.eks. 10.10.0.0/16."
  }
}

variable "subnets" {
  description = "Subnett som skal opprettes: navn => netnum innenfor adresserommet (cidrsubnet-offset)."
  type        = map(number)
}

variable "tags" {
  description = "Felles tags fra stacken. Tags arves ikke fra ressursgruppa i Azure."
  type        = map(string)
  default     = {}
}
