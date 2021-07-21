rode:
  url: http://rode.${namespace}.svc.cluster.local:50051

  auth:
    oidc:
      enabled: ${oidc_auth_enabled}
      clientId: ${oidc_client_id}
      issuerUrl: ${oidc_issuer}

appUrl: https://${rode_ui_host}

image:
%{~ if rode_ui_version != "" }
  tag: ${rode_ui_version}
%{~ endif }

ingress:
  enabled: true
  annotations:
    %{~ if oidc_auth_enabled }
    nginx.ingress.kubernetes.io/proxy-buffer-size: "16k"
    %{~ endif }
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  %{~ if ingress_class != "" }
    kubernetes.io/ingress.class: ${ingress_class}
  %{~ endif }
  hosts:
    - host: ${rode_ui_host}
      paths:
        - "/"
