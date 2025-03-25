#!/bin/bash

if [ -z "$1" ];
then
  echo "Please provide the analyzer ID returned from the postDocument.sh run"
  exit 1
fi

if [ -z "$ADPPROJECTID" ] || [ -z "$ADPBEARERTOKEN" ] || [ -z "$ADPHOST" ];
then
  echo "Please source the 01-GetToken.sh script first (source ./01-GetToken.sh)"
  exit 1
fi



curl -k --location \
     --request GET "https://$ADPHOST/adp/aca/v1/projects/$ADPPROJECTID/analyzers/$1" \
     --header "Authorization: Bearer $ADPBEARERTOKEN"
