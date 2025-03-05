terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
}

resource "akamai_edge_hostname" "virajdesai1terratemplate2-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  product_id    = "prd_Fresca"
  ip_behavior   = "IPV4"
  edge_hostname = "virajdesai1terratemplate2.edgesuite.net"
}

resource "akamai_property" "Viraj_Terra_Template1" {
  name        = "Viraj_Terra_Template1"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_Fresca"
  hostnames {
    cname_from             = "terratemplate1.gsslab.com"
    cname_to               = akamai_edge_hostname.virajdesai1terratemplate2-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }

  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "Viraj_Terra_Template1-staging" {
  property_id                    = akamai_property.Viraj_Terra_Template1.id
  contact                        = ["videsa@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.Viraj_Terra_Template1.latest_version : akamai_property.Viraj_Terra_Template1.staging_version
  network                        = "STAGING"
  note                           = "Using Terra Template"
  auto_acknowledge_rule_warnings = true
}

# NOTE: Be careful when removing this resource as you can disable traffic
# resource "akamai_property_activation" "Viraj_Terra_Template1-production" {
#   property_id                    = akamai_property.Viraj_Terra_Template1.id
#   contact                        = ["videsa@akamai.com"]
#   version                        = var.activate_latest_on_production ? akamai_property.Viraj_Terra_Template1.latest_version : akamai_property.Viraj_Terra_Template1.production_version
#   network                        = "PRODUCTION"
#   note                           = "True client ip"
#   auto_acknowledge_rule_warnings = false
# }
