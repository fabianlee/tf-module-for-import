
output "region" {
  value = try(data.google_client_config.this.region,"?")
}

output "project" {
  value = try(data.google_client_config.this.project,"?")
}

# show all output
output "mymodmap1-output-all" {
  value = module.mymodmap
}
