clair:
  enabled: false

expose:
  tls:
    certSource: ${harbor_cert_source}
  ingress:
    hosts:
      core: ${harbor_host}

registry:
  credentials:
    username: ${registry_user}

externalURL: https://${harbor_host}
