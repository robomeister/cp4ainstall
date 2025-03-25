#!/bin/bash

if [ -z "$1" ];
then
  echo "Please provide a file name"
  exit 1
fi

if [ -z "$ADPPROJECTID" ] || [ -z "$ADPBEARERTOKEN" ] || [ -z "$ADPHOST" ];
then
  echo "Please source the 01-GetToken.sh script first (source ./01-GetToken.sh)"
  exit 1
fi


curl -k --location \
     --request POST "https://$ADPHOST/adp/aca/v1/projects/$ADPPROJECTID/analyzers" \
     --header "Authorization: Bearer $ADPBEARERTOKEN"  \
     --form "file=@"$1"" --form "responseType="json"" --form "jsonOptions="dc,kvp,ocr,sn,hr,th,mt,ds,char"" > /tmp/adp.json

cat /tmp/adp.json | jq -r .status.message
echo "Analyzer ID:"
cat /tmp/adp.json | jq -r .result[0].data.analyzerId
