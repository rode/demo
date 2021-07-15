grafeas-elasticsearch:
  enabled: false

rode-ui:
  enabled: false

grafeas:
  host: "grafeas-server.${grafeas_namespace}.svc.cluster.local:8080"

elasticsearch:
  host: http://${elasticsearch_host}

debug: true

image:
%{~ if rode_version != "" }
  tag: "${rode_version}"
%{~ endif }

auth:
  oidc:
    enabled: ${oidc_auth_enabled}
    issuer: ${oidc_auth_issuer}
    requiredAudience: ${oidc_auth_required_audience}
    roleClaimPath: ${oidc_auth_role_claim_path}
    tlsInsecureSkipVerify: true
