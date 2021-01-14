clair:
  enabled: false

expose:
  ingress:
    hosts:
      core: ${harbor_host}

externalURL: http://${harbor_host}
