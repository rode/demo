rode:
  host: rode.${namespace}.svc.cluster.local:50051
  disableTransportSecurity: true

  auth:
    proxy:
      enabled: ${oidc_auth_enabled}

debug: true

image:
%{~ if tfsec_collector_version != "" }
  tag: "${tfsec_collector_version}"
%{~ endif }
