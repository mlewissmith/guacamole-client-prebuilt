#!/bin/bash
set -eu
myPath=$(realpath $0)
myDir=$(dirname ${myPath})
buildDir="${myDir}/guacamole-client"

cd ${buildDir}
mvn -Dmaven.javadoc.skip=true -DskipTests=true package
