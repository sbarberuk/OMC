#!/bin/bash

BASEDIR=$(dirname "$0")

source ${BASEDIR}/bash_functions

if [[ ! -e "${HOME}/.omc" ]]; then
   mkdir ${HOME}/.omc
else
   if [[ ! -d ${HOME}/.omc ]]; then
      echo ERROR : ${HOME}/.omc already exists and is not a directory
      exit 1
   fi
   if [[ -e ${HOME}/.omc/omc.properties ]]; then
      . ${HOME}/.omc/omc.properties
   fi
fi

read -e -i "${OCI_TENANT_NAME}" -p 'OCI Tenant Name: ' OCI_TENANT_NAME
read -e -i "${OMC_INSTANCE_NAME}" -p 'OMC Instance Name: ' OMC_INSTANCE_NAME
read -e -i "${OMC_INSTANCE_ID}" -p 'OMC Instance ID: ' OMC_INSTANCE_ID
read -e -i "${OMC_URL}" -p 'OMC URL: ' OMC_URL
read -e -i "${OMC_USERNAME}" -p 'OMC Username: ' OMC_USERNAME
read -sp 'OMC Password: ' OMC_PASSWORD
echo

sed \
	-e "s/<your_oci_tenant_name>/$(escape_sed ${OCI_TENANT_NAME})/g" \
	-e "s/<your_omc_instance_name>/$(escape_sed ${OMC_INSTANCE_NAME})/g" \
	-e "s/<your_omc_instance_id>/$(escape_sed ${OMC_INSTANCE_ID})/g" \
	-e "s/<your_omc_url>/$(escape_sed ${OMC_URL})/g" \
	-e "s/<your_omc_username>/$(escape_sed ${OMC_USERNAME})/g" \
	-e "s/<your_omc_password>/$(escape_sed ${OMC_PASSWORD})/g" ${BASEDIR}/omc.properties.template > ${HOME}/.omc/omc.properties
exit $?
