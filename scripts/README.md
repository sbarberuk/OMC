# Script Index

Script | Description
------ | -----------
bash_functions.sh | This is a utility script containing some functions that can be used in other bash scripts
addHostTags.py | Is a utility to add tags to all entities on a specific host
downloadAgent.sh | Is a simple script to download the latest agent
getEntities.sh | Calls an undocumented REST API to query entities

## bash_functions.sh
Functions in this script include

Function | Description
-------- | -----------
escape_sed | `escape_sed` is used to escape user input for piping into a sed

## addHostTags.py
`addHostTags.py` can be used to add the same tag and value to all entities with an `omc_uses` association to the host.

The script can be executed with the -h parameter to display the help.

```
./addHostTags.py -h
usage: addHostTags.py [-h] [-U URL] -H HOST -t TAG -v VALUE
                      [-O {omc_host_linux,omc_host_windows,omc_host_aix,omc_host_solaris}]
                      [-u USERNAME] [-p PASSWORD] [-c {Y,N,y,n}]

optional arguments:
  -h, --help            show this help message and exit
  -U URL, --url URL     URL to the OMC Instance, default=ENV(OMC_URL)
  -H HOST, --host HOST  hostname to add tag to
  -t TAG, --tag TAG     tag name to be added
  -v VALUE, --value VALUE
                        tag value be added
  -O {omc_host_linux,omc_host_windows,omc_host_aix,omc_host_solaris}, --ostype {omc_host_linux,omc_host_windows,omc_host_aix,omc_host_solaris}
                        OS Entity Type, default=omc_host_linux
  -u USERNAME, --username USERNAME
                        Oracle Management Cloud Username,
                        default=ENV(OMC_USERNAME)
  -p PASSWORD, --password PASSWORD
                        Oracle Management Cloud Password,
                        default=ENV(OMC_PASSWORD)
  -c {Y,N,y,n}, --cascade {Y,N,y,n}
                        cascade the tag to all entities with an omc_uses
                        association to the host, default=N
```
**NOTE:** Consider running `setup.sh`, followed by `set_env.sh` prior to running this script.
### Examples
To add a tag `NewTag` with a value of `NewValue` to a Windows host called `MyWindowsServer` and all the entities monitored by its agent you would run;
```
./addHostTags.py --host MyWindowsServer --ostype omc_host_windows --tag NewTag --value NewValue --cascade Y --URL omc-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.api.omc.ocp.oraclecloud.com --username myusername@abc.com --password myPassword
```
However if you have already executed `setup.sh` then you can omit `--URL`, `--username` and `--password`.  To add the same tag to a linux host you would execute;
```
./addHostTags.py -H MyLinuxServer -T NewTag -V NewValue -c Y
```
## downloadAgent.sh
`downloadAgent.sh` is a simple script to download the latest version of an OMC agent.
```
Usage: ./downloadAgent.sh [-h] [-i] [-a AGENT_TYPE] [-o OS_TYPE]

Downloads the latest agent version for a given (AGENT_TYPE) and operating system (OS_TYPE).

        -h              help
        -i              Don't download just show the command that would be run
        -a AGENT_TYPE   Default=cloudagent valid options are

                        cloudagent|gateway|apmjavaasagent|
                        apmdotnetagent|apmrucyagent|apmnodejsagent|
                        apmiosagent|apmandroidagent

        -o OS_TYPE      Default=linux.x86 valid options are

                        linux.x86|windows.x64|aix.ppc64|
                        solaris.sparc64|generic|android|ios

OMC does not autheticate the API call to download the agent software however the script caters for it just in case Oracle change their minds.

The script sources ~/.omc/omc.properties to set OMC_USERNAME, OMC_PASSWORD, OMC_INSTANCE_ID and OMC_URL
```
## getEntities.sh
`getEntities.sh`  Calls an undocumented REST API `/serviceapi/entityModel/data/entities` to query entities.

By default this REST API returns a maximum of 2000 entities.  If your query returns more than 2000 entities the response is paginated, currently this script does not support pagination.

The script takes a single optional parameter which must start with a `?` and followed by one or more the following parameters separated by an `&`.

Parameter | Description | Example
--------- | ----------- | -------
addOnPackage|the Add on package of the entities to be looked up|PREMIUM
availabilityStatus|the availability status of the entities to be looked up|UP
caseSensitive|displayNamePattern is case-sensitive or not|true
category|the category of the entities to be looked up|Databases
displayNamePattern|the displayNamePattern of the entities to be looked up|.*host.*
entityName|the entity name of the entities to be looked up|myHost
entityType|the entity type of the entities to be looked up|["omc_host_linux","omc_db"]
extraFields|a comma separated list of extraFields to be added to the response.|totalCount
licensePackage|the license package of the entities to be looked up|ENTERPRISE
limit|the number of entries in the result to be returend in one REST call|2000
offset|the offset into the result list when doing a query with limit|0
orderBy|a comma separated list of attributes with order (asc/desc) to be used for ordering the returned entities|entityType:asc,entityName:desc

For example to query all linux host entities with a display name pattern of **nonprod** you would run;
```
getEntities.sh "?entityType=omc_host_linux&displayNamePattern=nonprod"
```
