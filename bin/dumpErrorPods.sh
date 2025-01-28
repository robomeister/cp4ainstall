oc get pods | grep Error | awk '{print $1}' | xargs oc delete pod
