clair:
  enabled: false

expose:
  ingress:
    hosts:
      core: ${harbor_host}

registry:
  credentials:
    username: ${registry_user}

externalURL: http://${harbor_host}
