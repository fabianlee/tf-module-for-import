# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
# https://devopscube.com/setup-google-provider-backend-terraform/
  
terraform {

  required_version = ">= 0.14.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">4.65"
    }
  }

  # instead of state stored in remote gcs bucket, use local fileystem
  #backend "gcs" {
  #  bucket  = "${var.project}-terraformstate"
  #  prefix  = "default"
  #}

}

provider "google" {
      # do not need json key if using: gcloud auth application-default login
      #credentials = file("${path.module}/tf-creator.json")

      # these tf variables not required IF you export environment variables
      # export GOOGLE_PROJECT=xxxxxx; export GOOGLE_REGION=us-east1
      #project     = var.project
      #region      = var.region
      #zone        = var.zone
}

