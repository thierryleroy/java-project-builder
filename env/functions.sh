function check_parameter_exists() {
    if [ -z "$1" ]; then
        echo "Aucun compte. ex : ./create-release.sh CXXXXXXXX"
        exit 1
    fi
}

function check_account_format() {
    if [[ ! $1 =~ ^c[0-9]{8}$ ]]; then
        echo "Mauvais compte : $1"
        exit 1
    fi
}

function check_directory_exists() {
    if [ ! -d "$1" ]; then
        echo "Le répertoire $1 n'existe pas."
        exit 1
    fi
}

function check_file_exists() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "Le fichier $file n'existe pas."
        exit 1
    fi
}

function check_directory_not_exists() {
    local file=$1
    if [ -d "$file" ]; then
        echo "Le répertoire $file existe."
        exit 1
    fi
}

function ask_for_confirmation() {
    echo "Voulez-vous continuer ? (O/n)"
    read -r response

    if [[ ! "$response" =~ ^([oO][uU][iI]|[oO]|"")$ ]]; then
        echo "Arrêt du script."
        exit
    fi
}
function fetch_jdk() { 
    if [ ! -d "$JAVA_HOME" ]; then
        ./fetch-jdk.sh
    fi
}
function fetch_modules() {
    TAG=$1
    MODULES_DIR=$2
    ##rm -fr "$MODULES_DIR"
    check_directory_not_exists "$MODULES_DIR"
    git clone --single-branch --depth 1 -b $TAG git@github.com:thierryleroy/adherent-fo.git "$MODULES_DIR/adherent-fo"
}

function fetch_project() {
    TAG=$1
    MODULES_DIR=$2
    rm -fr "$MODULES_DIR"
    check_directory_not_exists "$MODULES_DIR"
    git clone --single-branch --recursive --depth 1 -b $TAG git@github.com:thierryleroy/adherent-fecfo.git "$MODULES_DIR/adherent-fecfo"
}

function get_property() {
    local property_file=$1
    local property_key=$2
    local property_value=$(grep -oP "^${property_key}=\K.*" "$property_file")
    echo "$property_value"
}
function get_host_from_url() {
    local url=$1
    local host=$(echo "$url" | awk -F[/:] '{print $4}')
    echo "$host"
}
function to_lower_case() {
    local str=$1
    local lower_case_str=$(echo "$str" | tr '[:upper:]' '[:lower:]')
    echo "$lower_case_str"
}
