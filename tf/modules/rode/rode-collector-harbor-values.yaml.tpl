rode:
  host: rode.${namespace}.svc.cluster.local:50051
  insecure: true

harbor:
  host: ${harbor_url}
  username: ${harbor_username}
  password: "${harbor_password}"
