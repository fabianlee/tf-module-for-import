variable name {
  type = string
}

# to remove module and all its resources from state
# terraform state rm module.mymodlist[\"<index>\"]

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id
# terraformm import module.mymodlist[\"<index>\"].random_id.bucket_prefix <randValue>
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
# terraform import module.mymodlist[\"<index>\"].google_service_account.default projects/<projId>/serviceAccounts/storage-sa-<name>@<projId>.iam.gserviceaccount.com
resource "google_service_account" "default" {
  account_id   = "storage-sa-${var.name}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic
# terraform import module.mymodlist[\"<index>\"].google_pubsub_topic.default projects/<projId>/topics/<topicId>
resource "google_pubsub_topic" "default" {
  name = "topic-${var.name}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
# terraform import module.mymodlist[\"<index>\"].google_storage_bucket.default projects/<bucketId>
resource "google_storage_bucket" "default" {
  name                        = "bucket-${var.name}-${random_id.bucket_prefix.hex}" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

# does not support import, must be recreated if not in state
resource "local_file" "myfile" {
  content  = "This is a file for ${var.name}"
  filename = "${var.name}.txt"
  # workaround for not having import: https://spacelift.io/blog/importing-exisiting-infrastructure-into-terraform
  #content  = file("./${var.name}.txt"
}

# does not support import, must be recreated/versioned if not in state
# https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/storage_bucket_object#import
resource "google_storage_bucket_object" "default" {
  name   = "${var.name}.txt"
  bucket = google_storage_bucket.default.name
  # if using 'source', the file content is not kept in state file
  #source = "./zipbackup.tgz"
  # if using 'content', the file content is kept in state file
  content = local_file.myfile.content
}
