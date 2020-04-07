#!/usr/bin/python3

import http.client
import mimetypes
import json
import argparse
import sys
from base64 import b64encode

def updateEntity(entityId,new_tags):
    """Updates entityId with new_tags

    entityId    string  Internal entityId for the OMC entity
    new_tags    <dict>  {"tagName","tagValue"}"""

    payload = ''
    conn = http.client.HTTPSConnection("nhssupplychainomc-supplychainnhs.omc.ocp.oraclecloud.com")
    conn.request("GET", "/serviceapi/entityModel/data/entities/"+entityId, payload, headers)
    res = conn.getresponse()
    data = res.read()
    my_data=data.decode("utf-8")
    sourceEntity=json.loads(my_data)
    sourceEntity["tags"].update(new_tags)
    
    # namespace is not returned from the getEntity API and the
    # PATCH APPI failes if namespace is not provided. The default
    # value for namespace is "EMAAS"
    
    sourceEntity.update(namespace)
       
    payload=json.dumps(sourceEntity)
    conn.request("PATCH", "/serviceapi/entityModel/data/entities/"+entityId, payload, headers)
    res = conn.getresponse()
    if res.status==200:
        print("Added "+str(new_tags)+" to "+sourceEntity["entityName"])

parser=argparse.ArgumentParser()
parser.add_argument("-H","--host",required=True,help="hostname to add tag to")
parser.add_argument("-t","--tag",required=True,help="tag name to be added")
parser.add_argument("-v","--value",required=True,help="tag value be added")
parser.add_argument("-y","--ostype",default="omc_host_linux",choices=['omc_host_linux','omc_host_windows','omc_host_aix','omc_host_solaris'],help="OS Entity Type")
parser.add_argument("-u","--username",required=True,help="Oracle Management Cloud Username")
parser.add_argument("-p","--password",required=True,help="Oracle Management Cloud Password")
parser.add_argument("-c","--cascade",default="N",choices=['Y','N','y','n'],help="cascade the tag to all entities with an omc_uses association to the host")
args = parser.parse_args()

authorisation = b64encode(bytes(args.username+":"+args.password,'utf-8'))

conn = http.client.HTTPSConnection("nhssupplychainomc-supplychainnhs.omc.ocp.oraclecloud.com")
headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Basic %s' % authorisation.decode('utf-8')
}

###################################
####### Get entity details for host
###################################

payload = ''
conn.request("GET", "/serviceapi/entityModel/data/entities?entityType="+args.ostype+"&entityName="+args.host, payload, headers)
res = conn.getresponse()
data = res.read()
my_data=data.decode("utf-8")
json_data=json.loads(my_data)

entityId=json_data["items"][0]["entityId"]
new_tags = {args.tag:args.value}
namespace = {"namespace":"EMAAS"}

updateEntity(entityId,new_tags)

#####################################################################################
####### For each association using the sourceEntityId add the new tagKey and tagValue
#####################################################################################

if args.cascade.upper()=='Y':
    ##############################################
    ####### Get omc_uses associations for the host
    ##############################################

    payload = ''
    conn.request("GET", "/serviceapi/entityModel/data/entities/"+entityId+"/associations?tagKey=omc_uses", payload, headers)
    res = conn.getresponse()
    data = res.read()
    my_data=data.decode("utf-8")
    associations=json.loads(my_data)

    for association in associations:
        updateEntity(association["sourceEntityId"],new_tags)
        