clair:
  enabled: false

expose:
  tls:
    certSource: ${harbor_cert_source}
  ingress:
    hosts:
      core: ${harbor_host}

externalURL: ${harbor_protocol}://${harbor_host}
