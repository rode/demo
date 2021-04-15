#!/bin/sh
apk add curl
curl -vvvvvL --request POST \
  --url http://rode.${rode_namespace}.svc.cluster.local:50051/v1alpha1/policies \
  --header 'Content-Type: application/json' \
  --data '${policy_data}'


