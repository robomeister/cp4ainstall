#!/bin/bash

for deployname in cp4a-rabbitmq-ha cp4a-redis-ha-server; \
do oc scale --replicas=2 statefulset $deployname; \
done

for deployname in  cp4a-classifyprocess-classify cp4a-deep-learning cp4a-natural-language-extractor cp4a-ocr-extraction cp4a-postprocessing cp4a-processing-extraction cp4a-setup cp4a-spbackend; \
do oc scale --replicas=1 deployment $deployname; \
done

pod1=$(oc get pods | grep -v Completed | grep 0/1)
pod2=$(oc get pods | grep -v Completed | grep 0/2)
pod3=$(oc get pods | grep -v Completed | grep 1/2)
while [[ -n "$pod1" ]] || [[ -n "$pod2" ]] || [[ -n "$pod3" ]]
do echo "Waiting for pods  to start...."
pod1=$(oc get pods | grep -v Completed | grep 0/1)
pod2=$(oc get pods | grep -v Completed | grep 0/2)
pod3=$(oc get pods | grep -v Completed | grep 1/2)
sleep 10s
done
