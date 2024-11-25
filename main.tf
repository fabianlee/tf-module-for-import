locals {
  # list of mod names
  mod_list = {
    "a" = { name = "a",size=1 }
    "b" = { name = "b",size=2 }
    "c" = { name = "c",size=3 }
  }
}

data "google_client_config" "this" {}

# include module based on attribute from list of objects
module "mymodlist" {
  source = "./gcp-storage-bucket"

  # entire list
  #for_each = local.mod_list

  #  filter list based on object attribute
  for_each = { for k,v in local.mod_list : k => v if !contains(["c"],v.name) }
 
  # variables
  name = "${each.key}"
}

