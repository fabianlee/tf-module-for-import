locals {
  # list of mod names
  mod_map = {
    "a" = { name = "a",size=1 }
    "b" = { name = "b",size=2 }
    "c" = { name = "c",size=3 }
  }

  mod_list = [ "x", "y" ]
}

data "google_client_config" "this" {}

# include module based on attribute from list of objects
module "mymodmap" {
  source = "./gcp-storage-bucket"

  # entire list
  #for_each = local.mod_map

  # filter list based on object attribute
  for_each = { for k,v in local.mod_map : k => v if !contains(["c"],v.name) }
 
  # variables
  name = "${each.key}"
}

module "mymodlist" {
  source = "./gcp-storage-bucket"

  # entire list
  for_each = toset(local.mod_list)

  # variables
  name = "${each.key}"
}

