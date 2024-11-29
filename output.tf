
output "region" {
  value = try(data.google_client_config.this.region,"?")
}

output "project" {
  value = try(data.google_client_config.this.project,"?")
}

output "mymodmap-output-all" {
  value = module.mymodmap
}
output "mymodlist-output-all" {
  value = module.mymodlist
}
