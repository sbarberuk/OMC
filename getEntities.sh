#!/bin/bash

source ~/.omc/omc.properties

GET_ENTITIES="https://${OMC_URL}/serviceapi/entityModel/uds/entities${1}"

curl -s \
-H 'Content-Type: application/json' \
-H "X-USER-IDENTITY-DOMAIN-NAME: ${OMC_INSTANCE_ID}" \
-u "${OMC_USERNAME}:${OMC_PASSWORD}" \
-X GET \
"${GET_ENTITIES}" | python -m json.tool

