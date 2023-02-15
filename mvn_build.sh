#!/bin/bash
set -eux
myName=$(realpath $0)
myDir=$(dirname ${myName})
buildDir="${myDir}/guacamole-client"

_prep() {
    cd ${myDir}
    git submodule init
    git submodule update
    rm -f *.jar *.war
}

_build() {
    cd ${myDir}
    mvn -f ${buildDir} -Dmaven.javadoc.skip=true -DskipTests=true package
}

_install() {
    cd ${myDir}
    cp -v ${buildDir}/guacamole/target/guacamole*.war ${myDir}
    for tdir in $(find ${buildDir}/extensions -type d -name "target")
    do
        for jarfile in $(find $tdir -name "*.jar")
        do
            cp -v ${jarfile} $myDir
        done
    done
}

case ${1:-all} in
    prep) _prep ;;
    build) _build ;;
    install) _install ;;
    all) _prep ; _build ; _install ;;
    *) echo "[ERROR]" >&2 ; exit 1 ;;
esac
