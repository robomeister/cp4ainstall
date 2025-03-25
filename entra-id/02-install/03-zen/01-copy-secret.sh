sedString="s/openshift-config/cp4a/g"
oc -n openshift-config get secret letsencrypt-certs -o yaml | sed $sedString | oc create -f -
