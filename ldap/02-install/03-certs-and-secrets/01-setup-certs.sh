#TLS Trust Certs for the downstream services that CP4A may contact
oc delete secret cert-tls-ibm-github
oc delete secret cert-tls-letsencrypt-root
oc delete secret cert-tls-ibmclouddb
oc delete secret cert-tls-entrust
oc delete secret cert-tls-servicenow


oc create secret generic cert-tls-ibm-github --from-file=tls.crt=./certs/github.ibm.com.root.pem
oc create secret generic cert-tls-letsencrypt-root --from-file=tls.crt=./certs/lets-encrypt-root.pem
oc create secret generic cert-tls-ibmclouddb --from-file=tls.crt=./certs/ibmclouddb.pem
oc create secret generic cert-tls-entrust --from-file=tls.crt=./certs/entrust-all.pem
oc create secret generic cert-tls-servicenow --from-file=tls.crt=./certs/service-now-all.pem

