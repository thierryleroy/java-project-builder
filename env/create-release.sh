SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd $DIR

source functions.sh
 


## Main

check_parameter_exists "$1"

COMPTE=$(to_lower_case "$1")

check_account_format "$COMPTE"

COMPTE_DIR=$COMPTE

check_directory_exists "$COMPTE_DIR"

CONFIG_DIR="$COMPTE_DIR/config"

check_directory_exists "$CONFIG_DIR"

CONFIG_FILE="$CONFIG_DIR/fr/fecfo/adherent/config.properties"
TAG_FILE="$COMPTE_DIR/tag.txt"
ENV_FILE="$COMPTE_DIR/env.txt"
MODULES_DIR="$COMPTE_DIR/modules"

check_file_exists "$TAG_FILE"
check_file_exists "$ENV_FILE"
check_file_exists "$CONFIG_FILE"

source "$ENV_FILE"
TAG=$(cat "$TAG_FILE")
PROGRAM_NAME="adherent-fecfo"
PROGRAM_VERSION="0.1.0-$TAG"
RUNTIME_ENV=$(to_lower_case "$ENV")
RELEASE_BASENAME="$PROGRAM_NAME-$PROGRAM_VERSION-$COMPTE-$RUNTIME_ENV"
RELEASE_DIR="$COMPTE_DIR/release/$RELEASE_BASENAME"

URL=$(get_property "$CONFIG_FILE" "application.url")
HOST=$(get_host_from_url "$URL")

## Fetch modules
fetch_project "$TAG" "$MODULES_DIR"


check_directory_exists "$MODULES_DIR"
$MODULES_DIR/adherent-fecfo/00-fetch-jdk.sh

. $MODULES_DIR/adherent-fecfo/java.profile

## Affichage des informations
echo "### CONFIG #####"
cat "$CONFIG_FILE"
echo "################"
echo
echo "### JAVA #######"
$JAVA_HOME/bin/java --version 
echo "################"
echo
echo "### BUILD ######"
echo "COMPTE : $COMPTE"
echo "URL : $URL"
echo "TAG : $TAG"
echo "ENV : $ENV"
echo "RELEASE : $RELEASE_BASENAME"
echo "################"
echo
ask_for_confirmation

## Build


BUILD_SCRIPT=$MODULES_DIR/adherent-fecfo/01-build.sh

check_file_exists $BUILD_SCRIPT

$BUILD_SCRIPT




rm -fr jre
MODULES=java.se,jdk.crypto.ec,java.base,jdk.localedata,jdk.xml.dom,jdk.unsupported,jdk.naming.dns
$JAVA_HOME/bin/jlink --add-modules $MODULES  --include-locales en,fr  --output jre



mkdir -p "$RELEASE_DIR/lib"
cp "run-$RUNTIME_ENV.sh" "$RELEASE_DIR/run.sh"
echo $TAG > $RELEASE_DIR/version.txt
cp -frL "jre" "$RELEASE_DIR"
cp -frL "$CONFIG_DIR" "$RELEASE_DIR/config/"
cp $MODULES_DIR/adherent-fecfo/dependencies/java/*.jar "$RELEASE_DIR/lib" 
cp -frL $MODULES_DIR/adherent-fecfo/modules/adherent-fo/sources/www/ "$RELEASE_DIR/www"
tar czf "$RELEASE_DIR.tgz"  -C "$RELEASE_DIR"  .

rm -fr "$RELEASE_DIR"

scp "$RELEASE_DIR.tgz" "ubuntu@$HOST:~/installation/03-release/"










