#!/bin/bash

LOCATION=eastus
NAME=juiceshop$RANDOM
RESOURCE_GROUP=$NAME
ACI_NAME=$NAME
DNS_NAME=$NAME
PORT=3000

if [ "$1" ]; then
   echo "Using '$1' to name Resource Group, ACI resource, and DNS subdomain."
   RESOURCE_GROUP=$1
   ACI_NAME=$1
   DNS_NAME=$1
else
   echo "Using '$NAME' to name Resource Group, ACI resource, and DNS subdomain."
fi

START_SECONDS=$(date +%s)

az group     create -l $LOCATION       -n $RESOURCE_GROUP
az container create -g $RESOURCE_GROUP -n $ACI_NAME --image bkimminich/juice-shop --dns-name-label $DNS_NAME --ports $PORT --ip-address public
az container show   -g $RESOURCE_GROUP -n $ACI_NAME --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
az container show   -g $RESOURCE_GROUP -n $ACI_NAME --out table

END_SECONDS=$(date +%s)
ELAPSED_SECONDS=$(($END_SECONDS - $START_SECONDS))

open http://$DNS_NAME.$LOCATION.azurecontainer.io:$PORT/

echo "→ Deployment time ⇒ $ELAPSED_SECONDS seconds."
echo "-------------------------------------------------------------------------"
echo "Cleanup:"
echo "az container delete -g $RESOURCE_GROUP -n $ACI_NAME"
echo "az group delete -g $RESOURCE_GROUP --no-wait --yes"
