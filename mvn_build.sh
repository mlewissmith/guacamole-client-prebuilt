#!/bin/bash
set -eu
myName=$(realpath $0)
myBasename=$(basename ${myName})
workDir=$(dirname ${myName})
buildDir="${workDir}/guacamole-client"


usage() {
    cat<<EOF
Usage: ${myBasename} [ prep | build | install | all | clean | help ]
    prep    - prepare build environment
    build   - execute buildscript (maven)
    install - drop build jarfiles in ${workDir}
    all     - (default) prep+build+install
    clean   - clean *all* untracked files 
              (including '${workDir}/*')
EOF
}

_prep() {
    cd ${workDir}
    git submodule update --init
    git submodule foreach git clean -xdf
    git submodule foreach git reset --hard
    git clean -X
}

_build() {
    cd ${workDir}
    mvn -f ${buildDir} -Dmaven.javadoc.skip=true -DskipTests=true package
}

_install() {
    cd ${workDir}
    for tdir in $(find ${buildDir}/{guacamole,extensions/guacamole-auth-*} -type d -name "target")
    do
        for jarfile in ${tdir}/guacamole-*.{war,jar}
        do
            [[ -e $jarfile ]] && cp -v -t ${workDir} ${jarfile}
        done
    done
}

_clean() {
    git clean -xdff
    git submodule foreach git clean -xdff
}

case ${1:-all} in
    prep) _prep ;;
    build) _build ;;
    install) _install ;;
    all) _prep ; _build ; _install ;;
    clean) _clean ;;
    help) usage ; exit 0 ;;
    *) usage ; exit 1 ;;
esac
