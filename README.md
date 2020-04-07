# Oracle Management Cloud Utilities

This project consists of several utilities to help with maanaging and using Oracle Management Cloud.  It is not a replacement for the official utilities, documentation or support.  These are just tools that have made my life easier.

Starting at the beginning with some very simple shell/python scripts to do things like getting a list of downloadable agents or installing agents or simply listing entities.  The intention is to extend this to more sophisticated tools and utilities.

## setup.sh
`setup.sh` will initialise your environment by creating a hidden omc directory in your home directory (`$HOME/.omc`)

The initialisation will check for the existance of the `$HOME/.omc`, if it is not a directory initialisation will fail.  

If a directory already exists then the initialisation will check for and source `omc.properties` and give you the opportunity to edit the values contained within.

You will prompted to enter the following variables;

Variable | Description
-------- | -----------
OCI_TENANT_NAME | This is the name of your cloud account, this is the name of the account you used when you signed up for Oracle Cloud
OMC_INSTANCE_NAME | This is the name associated with the OMC Instance, this is the name displayed in viewing the instance in the Oracel Cloud MyServices Console which is access via https://myservices-<OCI_TENANT_NAME>.console.oraclecloud.com/mycloud/cloudportal/cloudHome
OMC_INSTANCE_ID | This is the value represented in the UI under the Administartion -> Agents -> Download Agent Page
OMC_URL | This is the value represented in the UI under the Administartion -> Agents -> Download Agent Page, when entering leave off the https:// as this will get added by the utilities that need it
OMC USERNAME | This is the login name for the OMC Instance
OMC_PASSWORD | This is the password associated with the OMC_USERNAME parameter

The initialisation script uses the `omc.properties.template` file and substitues the values entered, creating `$HOME/.omc/omc.properties`

## set_env.sh
`set_env.sh` is a simple utility script to export the values in `$HOME/.omc/omc.properties` as environment variables
