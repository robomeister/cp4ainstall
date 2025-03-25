#!/bin/bash

#for deployname in cp4a-callerapi cp4a-classifyprocess-classify cp4a-deep-learning cp4a-natural-language-extractor cp4a-ocr-extraction cp4a-pdfprocess cp4a-postprocessing cp4a-processing-extraction cp4a-setup cp4a-spbackend cp4a-updatefiledetail cp4a-utf8process; \

for deployname in  cp4a-classifyprocess-classify cp4a-deep-learning cp4a-natural-language-extractor cp4a-ocr-extraction cp4a-postprocessing cp4a-processing-extraction cp4a-setup cp4a-spbackend; \
do oc scale --replicas=0 deployment $deployname; \
done

for deployname in cp4a-rabbitmq-ha cp4a-redis-ha-server; \
do oc scale --replicas=0 statefulset $deployname; \
done

pod=$(oc get pods | grep Terminating)
while [ -n "$pod" ]
do echo "Waiting for all pods to terminate...."
pod=$(oc get pods | grep Terminating)
sleep 10s
done
