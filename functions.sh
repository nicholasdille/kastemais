merge_documents() {
    local TEMP_DIR=$1
    shift

    type yq >/dev/null || (echo "ERROR: Tool yq is missing"; return 1)
    type yaml-patch >/dev/null || (echo "ERROR: Tool yaml-patch is missing"; return 1)

    while [[ "$#" -gt 0 ]]; do
        test -f "$1" || (echo "ERROR: File $1 does not exist"; return 1)
        cat "$1"
        shift
    done | yq -d'*' prefix - [+].value | yq -d'*' merge - "templates/patch-template.yaml" | grep -vE "^---$" >"${TEMP_DIR}/~patch-list.yaml"

    cat "templates/list.yaml" | yaml-patch -o "${TEMP_DIR}/~patch-list.yaml" >"${TEMP_DIR}/~all.yaml"
}

merge_app() {
    local APP=$1
    test -d ./app/${APP} || (
        echo "ERROR: App ${APP} does not exist in ./app/."
        return 1
    )

    merge_documents ./app/${APP} $(ls ./app/${APP}/*.yaml)
}