#!/bin/bash
# Source this script with either of these two commands:
# source ./getToken.sh
# . ./getToken.sh

USERID="icpadmin"
PASSWORD="cloudPakPassw0rd!"


export ADPHOST="ZEN HOSTNAME OF YOuR CLuSTER"
export ADPBEARERTOKEN=`curl -u "$USERID:$PASSWORD" -Ssk -X GET "https://$ADPHOST/v1/preauth/validateAuth" | jq -r '.accessToken'`


#Change the PROJECT ID to a PROJECT_GUID found in your ADP TENANTINFO table
export ADPPROJECTID="YOUR APP PROJECT ID"
