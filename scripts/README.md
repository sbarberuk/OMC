# Script Index

Script | Description
------ | -----------
bash_functions.sh | This is a utility script containing some functions that can be used in other bash scripts
addHostTags.py | Is a utility to add tags to all entities on a specific host
downloadAgent.sh | Is a simple script to download the latest agent
getEntities.sh | Simply calls the REST API https://docs.oracle.com/en/cloud/paas/management-cloud/raomc/op-entitymodel-uds-entities-query-post.html to query entities

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

## downloadAgent.sh
`downloadAgent.sh` is a simple script to download the latest version of an OMC agent.  The script takes two optional positional parameters;

Parameter | Value 
--------- | ----- 
$1 | This parameter represents the type of OMC agent; Default value is `cloudagent`; Possible values are;<br/>cloudagent<br/>gateway<br/>apmjavaasagent<br/>apmdotnetagent<br/>apmrubyagent<br/>apmnodejsagent<br/>apmiosagent<br/>apmandroidagent
$2 | The second parameter is used to identify the Operating System type for the agent;  Default value is `linux.x86`; Options are;<br/>linux.x86<br/>windows.x64<br/>aix.ppc64<br/>solaris.sparc64<br/>generic<br/>android<br/>ios

## getEntities.sh


