#These ones are for the common services
oc delete pod -l app=platform-auth-service
oc delete pod -l app=platform-identity-provider
oc delete pod -l name=operand-deployment-lifecycle-manager


#oc edit zenservice
#oc describe zenservice
#wait a while
#oc delete pod -l name=ibm-zen-operator --> probably don't need to do this as it should reconcile on its own


#oc delete pod -l component=usermgmt
#oc delete pod -l app.kubernetes.io/component=ibm-nginx

