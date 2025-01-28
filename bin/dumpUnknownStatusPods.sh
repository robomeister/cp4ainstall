oc get pods | grep ContainerStatusUnknown | awk '{print $1}' | xargs oc delete pod
