clair:
  enabled: false

updateStrategy:
  type: Recreate

expose:
  tls:
    certSource: ${harbor_cert_source}
  ingress:
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    %{~ if ingress_class != "" }
      kubernetes.io/ingress.class: ${ingress_class}
    %{~ endif }
    hosts:
      core: ${harbor_host}

registry:
  credentials:
    username: ${registry_user}

notary:
  enabled: false

chartmuseum:
  enabled: false

externalURL: https://${harbor_host}
