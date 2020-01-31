PROJECT_DIR=$(dirname $(readlink -f $0))
. "${PROJECT_DIR}/functions.sh"
cd "${PROJECT_DIR}"

TEMP_DIR=$(mktemp --directory --tmpdir="${PROJECT_DIR}")
echo "### Using temporary directory ${TEMP_DIR}."

merge_app nginx

echo "### Removing temporary directory"
rm -rf "${TEMP_DIR}"