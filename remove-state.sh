#!/bin/bash
#
# Usage: moduleName moduleIndex
#

function show_usage() {
  echo "Usage: moduleName moduleIndex"
  echo "Example: mymodmap|mymodlist a|x"
  exit 1
}

moduleName="$1"
moduleIndex="$2"

# make sure all arguments have been provided
[[ -n "$moduleName" && -n "$moduleIndex" ]] || show_usage

echo "moduleName = $moduleName"
echo "moduleIndex = $moduleIndex"

set -x
terraform state rm module.${moduleName}[\"$moduleIndex\"]
terraform state list
set +x
