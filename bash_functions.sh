#!/bin/bash

function escape_sed() {
   local NEWVAR="${1//'\'/'\\'}"
   NEWVAR="${NEWVAR//'/'/'\/'}"
   NEWVAR="${NEWVAR//'&/'/'\&'}"

   echo ${NEWVAR}
}
