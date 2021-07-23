rode:
  host: ${rode_host}

  disableTransportSecurity: true

  auth:
    oidc:
      enabled: ${oidc_auth_enabled}
      clientId: ${oidc_client_id}
      tokenUrl: ${oidc_token_url}
      tlsInsecureSkipVerify: true

harbor:
  host: ${harbor_url}
  username: ${harbor_username}
  insecure: ${harbor_insecure}

debug: true

image:
%{~ if harbor_collector_version != "" }
  tag: "${harbor_collector_version}"
%{~ endif }
