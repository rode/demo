rode:
  host: rode.${namespace}.svc.cluster.local:50051
  insecure: true

harbor:
  host: ${harbor_url}
  username: ${harbor_username}
  insecure: ${harbor_insecure}

debug: true
