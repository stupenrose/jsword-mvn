#!/bin/bash

set -e

BASE=`pwd`
WORKING="$BASE/target"

rm -rf $WORKING
mkdir -p $WORKING
cd $WORKING

curl http://www.crosswire.org/ftpmirror/pub/jsword/release/jsword-1.6-src.zip > jsword-1.6-bin.zip
unzip jsword-1.6-bin.zip


function makeSourceZip {
  cd $WORKING/jsword-1.6/$1
  zip -r $WORKING/$2-1.6.src.jar *
}

makeSourceZip bibledesktop bibledesktop
makeSourceZip jsword jsword
makeSourceZip common jsword-common


cd $WORKING
curl http://www.crosswire.org/ftpmirror/pub/jsword/release/jsword-1.6-bin.zip > jsword-1.6-bin.zip
unzip jsword-1.6-bin.zip



function installAndDeploy {
  POM=$1
  JAR=$2
  SRC=$3

  mvn install:install-file -Dfile=$JAR -DpomFile=$POM -Dsources=$SRC
  mvn deploy:deploy-file   -Dfile=$JAR -DpomFile=$POM -Dsources=$SRC  -Durl=file://$BASE/repo

}


installAndDeploy "$BASE/jsword.pom.xml" "jsword-1.6/jsword-1.6.jar" "$WORKING/jsword-1.6.src.jar"
installAndDeploy "$BASE/jsword-common.pom.xml" "jsword-1.6/jsword-common-1.6.jar" "$WORKING/jsword-common-1.6.src.jar"
installAndDeploy "$BASE/bibledesktop.pom.xml" "jsword-1.6/bibledesktop-1.6.jar" "$WORKING/bibledesktop-1.6.src.jar"
