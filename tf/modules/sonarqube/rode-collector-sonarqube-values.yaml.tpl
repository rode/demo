rode:
  host: ${rode_host}

  disableTransportSecurity: true

  auth:
    oidc:
      enabled: ${oidc_auth_enabled}
      clientId: ${oidc_client_id}
      tokenUrl: ${oidc_token_url}

debug: true

image:
%{~ if sonarqube_collector_version != "" }
  tag: "${sonarqube_collector_version}"
%{~ endif }
