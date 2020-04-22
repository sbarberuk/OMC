#!/usr/bin/python3

import http.client
from http.client import HTTPException
import mimetypes
import json
import argparse
import sys
import os
from base64 import b64encode

def updateEntity(entityId,new_tags):
    """Updates entityId with new_tags

    entityId    string  Internal entityId for the OMC entity
    new_tags    <dict>  {"tagName","tagValue"}"""

    payload = ''
    conn = http.client.HTTPSConnection(args.url)
    conn.request("GET", "/serviceapi/entityModel/data/entities/"+entityId, payload, headers)
    res = conn.getresponse()
    data = res.read()
    my_data=data.decode("utf-8")
    sourceEntity=json.loads(my_data)
    sourceEntity["tags"].update(new_tags)
    
    # namespace is not returned from the getEntity API and the
    # PATCH API fails if namespace is not provided. The default
    # value for namespace is "EMAAS"
    
    sourceEntity.update(namespace)
       
    payload=json.dumps(sourceEntity)
    conn.request("PATCH", "/serviceapi/entityModel/data/entities/"+entityId, payload, headers)
    res = conn.getresponse()
    if res.status==200:
        print("Added "+str(new_tags)+" to "+sourceEntity["entityName"])

parser=argparse.ArgumentParser()
parser.add_argument("-U","--url",default=os.getenv('OMC_URL'),help="URL to the OMC Instance, default=ENV(OMC_URL)")
parser.add_argument("-H","--host",required=True,help="hostname to add tag to")
parser.add_argument("-t","--tag",required=True,help="tag name to be added")
parser.add_argument("-v","--value",required=True,help="tag value be added")
parser.add_argument("-O","--ostype",default="omc_host_linux",choices=['omc_host_linux','omc_host_windows','omc_host_aix','omc_host_solaris'],help="OS Entity Type, default=omc_host_linux")
parser.add_argument("-u","--username",default=os.getenv('OMC_USERNAME'),help="Oracle Management Cloud Username, default=ENV(OMC_USERNAME)")
parser.add_argument("-p","--password",default=os.getenv('OMC_PASSWORD'),help="Oracle Management Cloud Password, default=ENV(OMC_PASSWORD)")
parser.add_argument("-c","--cascade",default="N",choices=['Y','N','y','n'],help="cascade the tag to all entities with an omc_uses association to the host, default=N")
args = parser.parse_args()

if args.url is None:
    raise Exception("OMC_URL is not defined")

authorisation = b64encode(bytes(str(args.username)+":"+str(args.password),'utf-8'))

conn = http.client.HTTPSConnection(args.url)
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
if res.status != 200:
    raise HTTPException('Failed to query entities HTTP Error {}:{}'.format(res.status, res.reason))

data = res.read()
my_data=data.decode("utf-8")
json_data=json.loads(my_data)

if json_data["count"] == 0:
    raise Exception("Host entity not found")

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
        
