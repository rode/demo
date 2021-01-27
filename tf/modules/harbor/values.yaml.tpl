clair:
  enabled: false

expose:
  tls:
    certSource: ${harbor_cert_source}
  ingress:
    hosts:
      core: ${harbor_host}

externalURL: https://${harbor_host}
