#!/bin/bash

# Based on the WolfSSL Espressif install script


MKDCMD='/bin/mkdir'
CPDCMD='/bin/cp'

SCRIPTDIR=`dirname $0`
SCRIPTDIR=`cd $SCRIPTDIR && pwd -P`
WOLFSSLLIB_TRG_DIR=${SCRIPTDIR}
SRC_DIR=${1}
WOLFSSL_ESPIDFDIR="${SRC_DIR}/IDE/Espressif/ESP-IDF"

if [ ! -d ${SRC_DIR} ]; then
	echo "No source dir given"
	exit 1
fi

if [ ! -d "${SRC_DIR}/wolfssl" ]; then
	echo "src dir does not contain wolfssl files"
	exit 1
fi

if [ ! -d "${WOLFSSLLIB_TRG_DIR}/wolfcrypt" ]; then
	echo "WOLFSSLLIB_TRG_DIR does not contain a wolfssl installation"
	exit 1
fi

function die() {
	echo "Error occured"
	exit 1
}


rm -r ${WOLFSSLLIB_TRG_DIR}/src || die
rm -r ${WOLFSSLLIB_TRG_DIR}/wolfcrypt || die
rm -r ${WOLFSSLLIB_TRG_DIR}/wolfssl || die
rm -r ${WOLFSSLLIB_TRG_DIR}/test || die
rm -r ${WOLFSSLLIB_TRG_DIR}/include || die

${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/src || die
${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/wolfcrypt || die
${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/wolfcrypt/src || die
${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/wolfssl || die
${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/test || die
${MKDCMD} ${WOLFSSLLIB_TRG_DIR}/include || die

# copying ... files in src/ into $WOLFSSLLIB_TRG_DIR/src
${CPDCMD} ${SRC_DIR}/src/*.c ${WOLFSSLLIB_TRG_DIR}/src/ || die

${CPDCMD} -r ${SRC_DIR}/wolfcrypt/src/*.{c,i} ${WOLFSSLLIB_TRG_DIR}/wolfcrypt/src/ || die
${CPDCMD} -r ${SRC_DIR}/wolfcrypt/src/port  ${WOLFSSLLIB_TRG_DIR}/wolfcrypt/src/port/ || die
${CPDCMD} -r ${SRC_DIR}/wolfcrypt/test ${WOLFSSLLIB_TRG_DIR}/wolfcrypt/ || die
${CPDCMD} -r ${SRC_DIR}/wolfcrypt/benchmark ${WOLFSSLLIB_TRG_DIR}/wolfcrypt/ || die

${CPDCMD} -r ${SRC_DIR}/wolfssl/*.h ${WOLFSSLLIB_TRG_DIR}/wolfssl/ || die
${CPDCMD} -r ${SRC_DIR}/wolfssl/openssl ${WOLFSSLLIB_TRG_DIR}/wolfssl/ || die
${CPDCMD} -r ${SRC_DIR}/wolfssl/wolfcrypt ${WOLFSSLLIB_TRG_DIR}/wolfssl/ || die

# user_settings.h
${CPDCMD} -r ${WOLFSSL_ESPIDFDIR}/user_settings.h ${WOLFSSLLIB_TRG_DIR}/include/ || die
${CPDCMD} -r ${WOLFSSL_ESPIDFDIR}/dummy_config_h ${WOLFSSLLIB_TRG_DIR}/include/config.h || die

# unit test app
${CPDCMD} -r ${WOLFSSL_ESPIDFDIR}/test/* ${WOLFSSLLIB_TRG_DIR}/test/ || die

${CPDCMD} ${WOLFSSL_ESPIDFDIR}/libs/CMakeLists.txt ${WOLFSSLLIB_TRG_DIR}/ || die
${CPDCMD} ${WOLFSSL_ESPIDFDIR}/libs/component.mk ${WOLFSSLLIB_TRG_DIR}/ || die

exit 0
