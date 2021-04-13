#!/bin/sh
apk add curl
curl -vvvvvL --request POST \
  --url http://rode.rode-demo.svc.cluster.local:50052/v1alpha1/policies \
  --header 'Content-Type: application/json' \
  --data '${policy_data}'


