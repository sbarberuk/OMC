#!/bin/bash

BASEDIR=$(dirname "$0")

source ${BASEDIR}/scripts/bash_functions.sh

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

echo "
OCI Tenant Name is the name of the account you used when you signed up for Oracle Cloud
"
read -e -i "${OCI_TENANT_NAME}" -p 'OCI Tenant Name: ' OCI_TENANT_NAME

echo "
OMC Instance Name is the name associated with the OMC Instance, this is the name displayed when viewing the instance in the Oracel Cloud MyServices Console which is accessed via https://myservices-${OCI_TENANT_NAME}.console.oraclecloud.com/mycloud/cloudportal/cloudHome
"
read -e -i "${OMC_INSTANCE_NAME}" -p 'OMC Instance Name: ' OMC_INSTANCE_NAME

echo "
OMC Instance ID is the value represented in the UI under the Administartion -> Agents -> Download Agent Page
"
read -e -i "${OMC_INSTANCE_ID}" -p 'OMC Instance ID: ' OMC_INSTANCE_ID

echo "
OMC URL is the value represented in the UI under the Administartion -> Agents -> Download Agent Page, when you enter this value it will be saved without the https:// prefix
"
read -e -i "${OMC_URL}" -p 'OMC URL: ' OMC_URL

OMC_URL=${OMC_URL/'https://'/}
OMC_URL=${OMC_URL/'HTTPS://'/}

echo "
OMC Username is the username associated with the OMC Instance ${OMC_INSTANCE_NAME}
"
read -e -i "${OMC_USERNAME}" -p 'OMC Username: ' OMC_USERNAME

echo "
OMC Password is the password asociated with the OMC Username ${OMC_USERNAME}
"
read -sp 'OMC Password: ' OMC_PASSWORD
echo

sed \
	-e "s/<your_oci_tenant_name>/$(escape_sed ${OCI_TENANT_NAME})/g" \
	-e "s/<your_omc_instance_name>/$(escape_sed ${OMC_INSTANCE_NAME})/g" \
	-e "s/<your_omc_instance_id>/$(escape_sed ${OMC_INSTANCE_ID})/g" \
	-e "s/<your_omc_url>/$(escape_sed ${OMC_URL})/g" \
	-e "s/<your_omc_username>/$(escape_sed ${OMC_USERNAME})/g" \
	-e "s/<your_omc_password>/$(escape_sed ${OMC_PASSWORD})/g" \
	-e "s/<your_basedir>/$(escape_sed ${BASEDIR})/g" ${BASEDIR}/templates/omc.properties.template > ${HOME}/.omc/omc.properties
exit $?
