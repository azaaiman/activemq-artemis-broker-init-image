#!/bin/bash

function performReplaceAll {
  _sourceBrokerFile="$1"
  _targetBrokerFile="$2"

  _sourceBrokerXml=`cat ${_sourceBrokerFile}`
  _targetBrokerXml=`cat ${_targetBrokerFile}`

  if [[ ${_sourceBrokerXml} =~ "<diverts>"(.*)"</diverts>" ]]; then
      echo Match found
      sourceDivertsBlock=${BASH_REMATCH[1]}
      totalLines="";
      while IFS= read -r line; do
        totalLines=${totalLines}"\\n"$line
      done <<< "${sourceDivertsBlock}"
      #replace broker2.xml with the result
      sed -i ':a;N;$!ba; s|<\/address-settings>|<\/address-settings><diverts>'"${totalLines}"'<\/diverts>|' ${_targetBrokerFile}
  fi
}

function updateDiverts() {
  sourceBrokerFile="$1"
  targetBrokerFile="$2"

  echo "Updating diverts from operator"

  echo "Doing replace all..."
  performReplaceAll "${sourceBrokerFile}" "${targetBrokerFile}"
  echo Done.
}

if [[ -f "${TUNE_PATH}/broker.xml" ]]; then
    echo "yacfg broker.xml exists."
    updateDiverts "${TUNE_PATH}/broker.xml" "${CONFIG_INSTANCE_DIR}/etc/broker.xml"
fi
