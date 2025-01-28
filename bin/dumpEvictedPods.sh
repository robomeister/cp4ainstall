oc get pods | grep Evicted | awk '{print $1}' | xargs oc delete pod
