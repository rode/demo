#!/bin/sh
apk add curl jq

%{~ if oidc_auth_enabled }
accessToken=$(
    curl -s --fail -k \
        -d "username=$${USERNAME}" \
        -d "password=$${PASSWORD}" \
        -d "client_id=$${CLIENT_ID}" \
        -d "client_secret=$${CLIENT_SECRET}" \
        -d "grant_type=password" \
        "${oidc_token_url}" \
    | jq -r '.access_token'
)
%{~ endif }

%{ for policy in policies ~}
curl -vvvvvL http://rode.${rode_namespace}.svc.cluster.local:50051/v1alpha1/policies \
  %{~ if oidc_auth_enabled ~}
  --header "Authorization: Bearer $${accessToken}" \
  %{~ endif ~}
  --header "Content-Type: application/json" \
  --data '${jsonencode(policy)}'
%{ endfor ~}
