#!/bin/bash

GIR_NAME="GLib-2.0"

function generate_arg-path_arg-g2s-exec_arg-gir-pre_arg-gir-path_arg-output-dir {
    local PACKAGE_PATH=$1
    local G2S_EXEC=$2
    local GIR_PRE=$3
    local GIR_PATH=$4
    local OUTPUT_DIR=$5

    local CALLER=$PWD

    cd $PACKAGE_PATH

    if [[ -z $OUTPUT_DIR ]]; then
        OUTPUT_DIR=Sources/$(package_name)
    else
        NEEDS_SINGLE_FILE=1
        rm -rf $OUTPUT_DIR
        mkdir -p $OUTPUT_DIR
    fi

    local GIR_PRE_ARGS=`for FILE in ${GIR_PRE}; do echo -n "-p ${GIR_PATH}/${FILE}.gir "; done`
    
    bash -c "${G2S_EXEC} -o ${OUTPUT_DIR} -m ${GIR_NAME}.module ${GIR_PRE_ARGS} ${GIR_PATH}/${GIR_NAME}.gir"

    for src in ${OUTPUT_DIR}/*-*.swift ; do
        sed -f ${GIR_NAME}.sed < ${src} | awk -f ${GIR_NAME}.awk > ${src}.out
        mv -f ${src}.out ${src}
        for ver in 2.62.0 ; do
            if pkg-config --atleast-version=$ver glib-2.0 ; then
                sed -f ${GIR_NAME}-$ver.sed < ${src} |        \
                awk -f ${GIR_NAME}-$ver.awk > ${src}.out
                mv -f ${src}.out ${src}
            fi
        done
        for ver in 2.60.0 ; do
            if pkg-config --max-version=$ver glib-2.0 ; then
                sed -f ${GIR_NAME}-$ver.sed < ${src} > ${src}.out
                mv -f ${src}.out ${src}
            fi
        done
        [[ $NEEDS_SINGLE_FILE == 1 ]] && cat ${src} >> ${OUTPUT_DIR}/Output.swift
    done
    [[ $NEEDS_SINGLE_FILE == 1 ]] && rm -f ${OUTPUT_DIR}/*-*.swift

    cd $CALLER
}

case $1 in
gir-name) echo $GIR_NAME;;
generate) echo $(generate_arg-path_arg-g2s-exec_arg-gir-pre_arg-gir-path_arg-output-dir "${@:2}");;
esac
