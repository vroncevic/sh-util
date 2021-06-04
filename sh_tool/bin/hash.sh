#!/bin/bash
#
# @brief   Load App/Tool/Script Configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_HASH=hash
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh

#
# @brief  Set key, value to hash structure
# @params Values required hash structure, key and value
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# hset $HASH_STRUCT $KEY $VALUE
#
function hset {
    eval "$1""$2"='$3'
}

#
# @brief  Get element from hash structure by key
# @params Values required key and hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ELEMENT_BY_KEY=$(hget "Serbia" capitals)
# printf "%s\n" "$ELEMENT_BY_KEY"
#
function hget {
    eval echo '${'"$1$2"'#hash}'
}

#
# @brief  Set key and value to hash structure
# @params Values required key, value and hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# set_item $key $value $HASH_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notif admin | user
# else
#    # false
#    # notify admin | user
# fi
#
function set_item {
    local KEY=$1 VALUE=$2 HASH_STRUCT=$3
    if [[ -n "${KEY}" && -n "${VALUE}" ]]; then
        hset ${HASH_STRUCT} ${KEY} ${VALUE}
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief  Get item from hash structure
# @params Values required key and config hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ELEMENT_BY_KEY=$(get_item "Netherlands" capitals)
# printf "%s\n" "$ELEMENT_BY_KEY"
#
function get_item {
    local KEY=$1 HASH_STRUCT=$2 VALUE="None"
    if [ -n "${KEY}" ]; then
        VALUE=$(hget ${HASH_STRUCT} "${KEY}")
    fi
    eval "echo "${VALUE}""
}

#
# @brief  Load additional App/Tool/Script configuration from file
# @params Values required path to file and config hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A capitals=()
# local HASH_STRUCTURE_CFG="`pwd`/hash_values.conf"
# get_configuration $HASH_STRUCTURE_CFG capitals
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#      local ELEMENT_BY_KEY=$(get_item "Netherlands" capitals)
#     printf "%s\n" "$ELEMENT_BY_KEY"
#     local ELEMENT_BY_KEY=$(get_item "Serbia" capitals)
#     printf "%s\n" "$ELEMENT_BY_KEY"
# fi
#
function get_configuration {
    local FILE=$1 HASH_STRUCT=$2 KEY VALUE
    if [[ -n "${FILE}" && -n "${HASH_STRUCT}" ]]; then
        IFS="="
        while read -r KEY VALUE
        do
            set_item ${KEY} ${VALUE} ${HASH_STRUCT}
        done < ${FILE}
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

