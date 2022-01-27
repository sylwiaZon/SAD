#!/bin/bash

INBOUNDNAME="my.examples/calcnodeinb"
DEPLOYNAME="my.examples/calcnodedep"
SERVICEURL="calc-node-<CLUSTER-NAME>.<CLUSTER-REFERENCE-DOMAIN>"
#SERVICEURL="calc-node-preview.vera.kumori.cloud"
CLUSTERCERT="cluster.core/wildcard.<CLUSTER-REFERENCE-DOMAIN>"
#CLUSTERCERT="cluster.core/wildcard.vera.kumori.cloud"

case $1 in

'deploy-inbound')
  kumorictl register inbound $INBOUNDNAME \
    --domain $SERVICEURL \
    --cert $CLUSTERCERT
  ;;

'deploy-calc')
  kumorictl register deployment $DEPLOYNAME \
    --deployment ./manifests/deployment \
    --comment "Calc service"
  ;;

'link')
  kumorictl link $DEPLOYNAME:calc $INBOUNDNAME
  ;;

# Test the calculator
'test')
  curl -sS -X POST  -d '{"expr": "sin(90)*5"}' -H "Content-Type: application/json" https://${SERVICEURL}/calc  | jq .
  #curl -sS -X POST  -d '{"expr": "wrong + expression"}' -H "Content-Type: application/json" https://${SERVICEURL}/calc  | jq .
  ;;

# Undeploy all (secrets, inbounds, deployments)
'undeploy-all')
  kumorictl unlink $DEPLOYNAME:calc $INBOUNDNAME
  kumorictl unregister deployment $DEPLOYNAME
  kumorictl unregister inbound $INBOUNDNAME
  ;;

esac