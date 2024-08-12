SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd $DIR

version="jdk-21.0.4+7"
filename="OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7"
url="https://github.com/adoptium/temurin21-binaries/releases/download/$version/$filename.tar.gz"
md5=

echo "Téléchargement de l'archive : $url"
mkdir jdks
cd jdks
wget  $url 
if test -f "$filename.tar.gz"
then 
tar xf "$filename.tar.gz"
cd $DIR
ln -s "jdks/$version" jdk


else
echo "Le fichier n'a pas pu être téléchargé : $url"
fi

source "java.profile"

rm -fr jre
MODULES=java.se,jdk.crypto.ec,java.base,jdk.localedata,jdk.xml.dom,jdk.unsupported,jdk.naming.dns
$JAVA_HOME/bin/jlink --add-modules $MODULES  --include-locales en,fr  --output jre
./jre/bin/java -version


