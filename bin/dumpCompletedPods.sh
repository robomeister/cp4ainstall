oc get pods | grep Completed | awk '{print $1}' | xargs oc delete pod
