#!/bin/bash

source ~/.omc/omc.properties

# AGENT_TYPE = cloudagent|gateway|apmjavaasagent|apmdotnetagent|apmrucyagent|apmnodejsagent|apmiosagent|apmandroidagent
# OS_TYPE	 = linux.x86|windows.x64|aix.ppc64|solaris.sparc64|generic|android|ios

AGENT_TYPE="${1:-cloudagent}"
OS_TYPE="${2:-linux.x64}"

GET_AGENT="${OMC_URL}/serviceapi/agentlifecycle/download/v1/${AGENT_TYPE}/${OS_TYPE}/latest"

curl -H 'Content-Type: application/json' \
	-H "X-USER-IDENTITY-DOMAIN-NAME: ${OMC_INSTANCE_ID}" \
	-u "${OMC_USERNAME}:${OMC_PASSWORD}" \
	-o ${AGENT_TYPE}_${OS_TYPE}.latest.zip \
	"${GET_AGENT}"

