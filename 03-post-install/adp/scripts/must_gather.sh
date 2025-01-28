#!/usr/bin/env bash

###############################################################################
# @---lm_copyright_start
# Licensed Materials - Property of IBM
# 5737-I23, 5900-A30
# Copyright IBM Corp. 2018 - 2022. All Rights Reserved.
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#@---lm_copyright_end
###############################################################################

#This script collects Mustgather information for Automation Document Processing 21.0.3.x and newer.
#It must be run from the deployed namespace.
#Last revision 1/27/23 to be current with 22.0.2 - RW

export SCRIPT_VERSION="22.0.2.A"
export TMP_DIR="/tmp/adpmust"
export LOGS_DIR="$TMP_DIR/logs"
export DESCPODS_DIR="$TMP_DIR/descpods"
export CAHIST_DIR="$TMP_DIR/cahist"
export TIMESTAMP=$(date "+%Y%m%d%H%M")
export MY_NAMESPACE=$(oc project --short=true)
export CP4BA_OPERATOR=$(oc get operator |awk {'print $1'} |grep "cp4a-operator")
export CP4BA_CLUSTER=$(oc get ICP4ACluster | awk {'print $1'} |grep -v "NAME")
export CONTAINERS=$(oc get pods| awk {'print $1'} |grep -v "NAME")
export CA_CONTAINERS=$(oc get deploy,sts -lapp.kubernetes.io/name=$CP4BA_CLUSTER-aca -oname | awk -F / {'print $2'} |grep -v redis-ha-server |grep -v rabbitmq-ha |sort)
export LOG_OUTPUT=$(oc extract configmap/$CP4BA_CLUSTER-aca-ini --to=- --keys=ibm_ca.ini 2>/dev/null|grep LOG_OUTPUT| awk -F "= " {'print $2'})

#Confirm cluster is valid
if [ -z "$CP4BA_CLUSTER" ]; then
  echo "CP4BACluster not found.  Verify you are in the correct namespace."
  echo "Exiting...."
  exit 1
else
  echo "Cluster name is $CP4BA_CLUSTER"
fi


function queryForOptions(){
  echo "======================================="
if [[ $LOG_OUTPUT != "stdout" ]]; then
  echo -e "\x1B[1;31mIs this script being run to troubleshoot an issue uploading or processing a document?  Saying yes will capture the Content Analyzer history but may significantly increase the mustgather file size.  Press Enter for default of no.\x1B[0m"
  echo -e "\x1B[1;31mCollect Content Analyzer history? (y/n)\x1B[0m:"
  read CAconfirm
  CAconfirm=$(echo "$CAconfirm" | tr '[:upper:]' '[:lower:]')
  
  if [[ $CAconfirm == "y" || $CAconfirm == "yes" ||  $CAconfirm == "Y" || $CAconfirm == "YES" ]]
  then
    export CAHISTORY="yes"
  else
    export CAHISTORY="no"
  fi  
else
  echo "Content Analyzer history logging turned off on this system."
  export CAHISTORY="no"
fi

}


function confirmInfo(){
  echo "======================================="
  echo -e "\x1B[1;31mThis script gathers the Mustgather information for Automation Document Processing and saves it to a tar.gz file.  You must be logged on to your cluster and associated to the namespace where CP4BA is being deployed before running this script.  The script requires write access to the tmp folder.\x1B[0m"

  while [[  $confirm != "n" && $confirm != "y" && $confirm != "yes" && $confirm != "no" ]]
  do
    echo
    echo -e "\x1B[1;31mNamespace/Project  = $MY_NAMESPACE\x1B[0m"
    echo -e "\x1B[1;31mCP4BA deployment   = $CP4BA_CLUSTER\x1B[0m"
    echo -e "\x1B[1;31mInclude CA History = $CAHISTORY\x1B[0m"
    echo -e "\x1B[1;31mWould you like to continue (y/n):\x1B[0m"
    read confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
  done

  if [[ $confirm == "n" || $confirm == "no" ||  $confirm == "N" || $confirm == "No" ]]; then
    echo "Exiting...."
    exit 1
  fi
}


function createDir(){
  if [[ ! -d $TMP_DIR ]]; then
    echo "Creating $TMP_DIR...."
    mkdir -p $TMP_DIR
    mkdir -p $LOGS_DIR
    mkdir -p $DESCPODS_DIR
    if [[ $CAHISTORY == "yes" ]]; then   
	    mkdir -p $CAHIST_DIR
    fi
  fi

  if [[ $? -ne 0 ]]; then
    echo -e "\x1B[1;31mFailed to create $TMP_DIR.  Please make sure you have permission to create sub-directories in /tmp\x1B[0m"
    echo "Exiting...."
    exit 1
  fi
}


function getOperatorYaml(){
  echo "======================================="
  echo "Getting CP4BA operator yaml"
  oc get operator $CP4BA_OPERATOR -o yaml > $TMP_DIR/cp4baoperator.yaml
}


function getCRYaml(){
  echo "======================================="
  echo "Getting custom resource yaml"
  oc get icp4acluster -o yaml > $TMP_DIR/customresource.yaml
}


function getVersion(){
  echo "======================================="
  echo "Getting version information"
  echo "Mustgather script version "$SCRIPT_VERSION > $TMP_DIR/version.txt
  echo "" >> $TMP_DIR/version.txt
  oc version >> $TMP_DIR/version.txt
}


function getNodes(){
  echo "======================================="
  echo "Getting node information"
  oc get nodes -o wide > $TMP_DIR/nodes.txt
  kubectl top nodes >> $TMP_DIR/nodes.txt
}


function getPods(){
  echo "======================================="
  echo "Getting pod information"
  oc get pods -o wide > $TMP_DIR/pods.txt
}


function getPodLogs(){
  echo "======================================="
  echo "Getting pod logs from $MY_NAMESPACE namespace"
  echo
  for CONTAINER in $(echo $CONTAINERS )
  do
    echo "Getting log for $CONTAINER"
    if [[ $CONTAINER =~ 'redis' ]]; then
      oc logs -c redis $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'auth-idp' ]]; then
      oc logs -c platform-identity-provider $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'auth-pap' ]]; then
      oc logs -c auth-pap $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'auth-pdp' ]]; then
      oc logs -c auth-pdp $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'mongodb-0' ]]; then
      oc logs -c icp-mongodb $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'platform-api-operator' ]]; then
      oc logs $CONTAINER > $LOGS_DIR/$CONTAINER.log
    elif [[ $CONTAINER =~ 'platform-api' ]]; then
      oc logs -c platform-api $CONTAINER > $LOGS_DIR/$CONTAINER.log
    else
      oc logs $CONTAINER > $LOGS_DIR/$CONTAINER.log
    fi
  done
}


function descPods(){
  echo "======================================="
  echo "Getting describe pod output"
  echo
  for CONTAINER in $(echo $CONTAINERS )
  do
    echo "Getting describe pod for $CONTAINER"
    oc describe pod $CONTAINER > $DESCPODS_DIR/$CONTAINER.txt
  done
}


function getRoutes(){
  echo "======================================="
  echo "Getting route information"
  oc get routes > $TMP_DIR/routes.txt
}


function getSecrets(){
  echo "======================================="
  echo "Getting secrets list"
  oc get secrets > $TMP_DIR/secrets.txt
}


function getStorageInfo(){
  echo "======================================="
  echo "Getting storage information"
  oc get sc > $TMP_DIR/storageclasses.txt
  oc get pv > $TMP_DIR/pv.txt
  oc get pvc > $TMP_DIR/pvc.txt
}


function getAnsLogs(){
  echo "======================================="
  echo "Getting Operator Ansible logs"
  CP4BA_OP_POD=$(oc get po --no-headers |grep ibm-cp4a-operator | awk {'print $1'})
  if [[ -n $CP4BA_OP_POD ]]; then
    oc exec $CP4BA_OP_POD -- tar -cf /tmp/ansible-$TIMESTAMP.tar /logs/$CP4BA_OP_POD/ansible-operator/runner/icp4a.ibm.com/v1/ICP4ACluster/$MY_NAMESPACE/$CP4BA_CLUSTER/artifacts 2>/dev/null
    oc cp $CP4BA_OP_POD:/tmp/ansible-$TIMESTAMP.tar $TMP_DIR/ansible-$TIMESTAMP.tar && oc exec $CP4BA_OP_POD -- rm -f /tmp/ansible-$TIMESTAMP.tar 2>/dev/null
  else
    echo "Cannot find Operator pod.  Will skip collecting Operator Ansible logs"
  fi
}


function getConfigMaps(){
  echo "======================================="
  echo "Getting configmaps"
  oc get cm $CP4BA_CLUSTER-aca-config -oyaml > $TMP_DIR/acaconfigmap.yaml
  oc get cm $CP4BA_CLUSTER-cp4ba-access-info -oyaml > $TMP_DIR/cp4baconfigmap.yaml
}


function getCAHistoryLogs(){
  echo "======================================="
  echo "Getting Content Analyzer history logs"
  if [[ $LOG_OUTPUT != "stdout" ]]; then
    for c in $(echo $CA_CONTAINERS | sed "s/,/ /g")
    do
    echo "Extracting history for $c"    
    if [[ $c == "$CP4BA_CLUSTER-spbackend" ]]; then
      aca=$(oc get po |grep $c | head -1 | awk {'print $1'})
      oc exec $aca -- tar -cf /var/www/app/current/$c.tar /var/log/$c 2>/dev/null
      oc cp $aca:/var/www/app/current/$c.tar $CAHIST_DIR/$c.tar && oc exec $aca -- rm -f /var/www/app/current/$c.tar 2>/dev/null
    else
      aca=$(oc get po |grep $c |grep -v "rr-" | head -1 | awk {'print $1'})
      oc exec  $aca -- tar -cf /app/$c.tar /var/log/$c 2>/dev/null
      oc cp $aca:/app/$c.tar $CAHIST_DIR/$c.tar && oc exec $aca -- rm -f /app/$c.tar 2>/dev/null
    fi
    done
  else
    echo "Content Analyzer history logs not available on system."
  fi
}


function compressFiles(){
  echo "======================================="
  echo "Compressing files"
  tar -czf /tmp/adpmust_$TIMESTAMP.tar.gz $TMP_DIR 2> /dev/null
  echo -e "\x1B[1;31mCreated compressed file /tmp/adpmust_$TIMESTAMP.tar.gz \x1B[0m"
  rm -rf $TMP_DIR
}  


# Main
queryForOptions
confirmInfo
createDir
getOperatorYaml
getCRYaml
getVersion
getNodes
getPods
getPodLogs
descPods
getRoutes
getSecrets
getStorageInfo
getAnsLogs
getConfigMaps

if [[ $CAHISTORY == "yes" ]]; then
  getCAHistoryLogs
fi
  
compressFiles

