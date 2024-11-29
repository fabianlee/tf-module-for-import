#!/bin/bash
#
# Usage: moduleName moduleIndex storageBucketHexID 
#

function show_usage() {
  echo "Usage: moduleName moduleIndex storageBucketHexID"
  echo "Example: mymodmap|mymodlist a|x b52992000bd5cb4e"
  echo ""
  echo "to list storage bucket ids: 'gcloud storage ls'"
  exit 1
}

# make sure these environment variables have been defined
[ -n "${GOOGLE_PROJECT}" ] || { echo "ERROR need to export env var $GOOGLE_PROJECT"; exit 1; }
[ -n "${GOOGLE_REGION}" ] || { echo "ERROR need to export env var $GOOGLE_REGION"; exit 1; }

moduleName="$1"
moduleIndex="$2"
TF_RAND_ID_HEX="$3"

# make sure all arguments have been provided
[[ -n "$moduleName" && -n "$moduleIndex" && -n "$TF_RAND_ID_HEX" ]] || show_usage

echo "moduleName = $moduleName"
echo "moduleIndex = $moduleIndex"
# need to lookup the random id originally used: 'gcloud storage ls'
# conversion of hex representation back to ID that can be used for import
# https://github.com/hashicorp/terraform-provider-random/issues/96
TF_RAND_ID=$(echo -en $TF_RAND_ID_HEX | xxd -r -p | base64 | tr '/+' '_-' | tr -d '=')
echo "TF HEX ID = $TF_RAND_ID_HEX , ID = $TF_RAND_ID"

# if you want to remove the entire module state first (and all its resources)
# terraform state list
# terraform state rm module.${moduleName}[\"$moduleIndex\"].random_id.bucket_prefix
# terraform state rm module.${moduleName}[\"$moduleIndex\"]
# terraform state list

# show commmands that are going to be run
set -x

terraform import module.${moduleName}[\"$moduleIndex\"].random_id.bucket_prefix $TF_RAND_ID

terraform import module.${moduleName}[\"$moduleIndex\"].google_service_account.default projects/${GOOGLE_PROJECT}/serviceAccounts/storage-sa-$moduleIndex@${GOOGLE_PROJECT}.iam.gserviceaccount.com

terraform import module.${moduleName}[\"$moduleIndex\"].google_pubsub_topic.default projects/${GOOGLE_PROJECT}/topics/topic-$moduleIndex

terraform import module.${moduleName}[\"$moduleIndex\"].google_storage_bucket.default projects/bucket-$moduleIndex-$TF_RAND_ID_HEX

terraform state list

set +x
