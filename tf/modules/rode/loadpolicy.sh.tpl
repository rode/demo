#!/bin/sh
apk add curl

sleep 120
%{ for policy in policies ~}
curl -vvvvvL http://rode.${rode_namespace}.svc.cluster.local:50051/v1alpha1/policies \
  --header 'Content-Type: application/json' \
  --data '${jsonencode(policy)}'
%{ endfor ~}