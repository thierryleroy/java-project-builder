SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd $DIR

COMPTE=$(basename `pwd`)
../create-release.sh $COMPTE
