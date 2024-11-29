locals {

  # map of module names
  mod_map = {
    "a" = { name = "a",size=1 }
    "b" = { name = "b",size=2 }
    "c" = { name = "c",size=3 }
  }

  # list of module names
  mod_list = [ "x", "y" ]
}

data "google_client_config" "this" {}

# modules based on attribute from map of objects
module "mymodmap" {
  source = "./gcp-storage-bucket"

  # OPTION #1: entire list, no filter
  #for_each = local.mod_map
  # OPTION #2: filter list based on object attribute
  for_each = { for k,v in local.mod_map : k => v if !contains(["c"],v.name) }
 
  # variables
  name = "${each.key}"
}

# modules based on list of string
module "mymodlist" {
  source = "./gcp-storage-bucket"

  # entire list
  for_each = toset(local.mod_list)

  # variables
  name = "${each.key}"
}

