#!/bin/bash

source ~/.omc/omc.properties

help()
{
	echo "Usage: $0 [-h] [-i] [-a AGENT_TYPE] [-o OS_TYPE]

Downloads the latest agent version for a given (AGENT_TYPE) and operating system (OS_TYPE).

	-h		help
	-i		Don't download just show the command that would be run
	-a AGENT_TYPE	Default=cloudagent valid options are
	
			cloudagent|gateway|apmjavaasagent|
			apmdotnetagent|apmrucyagent|apmnodejsagent|
			apmiosagent|apmandroidagent

	-o OS_TYPE	Default=linux.x86 valid options are
	
			linux.x86|windows.x64|aix.ppc64|
			solaris.sparc64|generic|android|ios

OMC does not autheticate the API call to download the agent software however the script caters for it just in case Oracle change their minds.

The script sources ~/.omc/omc.properties to set OMC_USERNAME, OMC_PASSWORD, OMC_INSTANCE_ID and OMC_URL
"
	exit 0
}

AGENT_TYPE="cloudagent"
OS_TYPE="linux.x64"

while getopts "hia:o:" opt; do
   case ${opt} in
      h ) help
	  ;;
      i ) INFO="Y"
	  ;;
      a ) AGENT_TYPE="$OPTARG"
	  ;;
      o ) OS_TYPE="$OPTARG"
	  ;;
   esac
done

GET_AGENT="https://${OMC_URL}/serviceapi/agentlifecycle/download/v1/${AGENT_TYPE}/${OS_TYPE}/latest"

AUTH=`echo ${OMC_USERNAME}:${OMC_PASSWORD} | base64`

CMD="curl \
	-H 'Content-Type: application/json' \
	-H 'Authorization: Basic ${AUTH}' \
	-H 'X-USER-IDENTITY-DOMAIN-NAME: ${OMC_INSTANCE_ID}' \
	-o ${AGENT_TYPE}_${OS_TYPE}.latest.zip \
	'${GET_AGENT}'"

if [ "$INFO" == "Y" ]
then
	echo $CMD
else
	eval "${CMD}"
	
fi

