
[ -n "${GOOGLE_PROJECT}" ] || { echo "ERROR need to export env var $GOOGLE_PROJECT"; exit 1; }
[ -n "${GOOGLE_REGION}" ] || { echo "ERROR need to export env var $GOOGLE_REGION"; exit 1; }

# need to lookup the random id originally used: 'gcloud storage ls'
TF_RAND_ID_HEX=b52992000bd5cb4e
# conversion of hex representation back to ID that can be used for import is tricky
# https://github.com/hashicorp/terraform-provider-random/issues/96
TF_RAND_ID=$(echo -en $TF_RAND_ID_HEX | xxd -r -p | base64 | tr '/+' '_-' | tr -d '=')
INDEX=b
echo "TF HEX ID = $TF_RAND_ID_HEX , ID = $TF_RAND_ID"

# if you want to remove the entire module state first (and all its resources)
# terraform state list
# terraform state rm module.mymodlist[\"$INDEX\"].random_id.bucket_prefix
# terraform state rm module.mymodlist[\"$INDEX\"]
# terraform state list

# show commmands that are going to be run
set -x

terraform import module.mymodlist[\"$INDEX\"].random_id.bucket_prefix $TF_RAND_ID

terraform import module.mymodlist[\"$INDEX\"].google_service_account.default projects/${GOOGLE_PROJECT}/serviceAccounts/storage-sa-$INDEX@${GOOGLE_PROJECT}.iam.gserviceaccount.com

terraform import module.mymodlist[\"$INDEX\"].google_pubsub_topic.default projects/${GOOGLE_PROJECT}/topics/topic-$INDEX

terraform import module.mymodlist[\"$INDEX\"].google_storage_bucket.default projects/bucket-$INDEX-$TF_RAND_ID_HEX

set +x
