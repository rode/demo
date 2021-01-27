rode:
  host: rode.rode.svc.cluster.local:50051
  insecure: true

harbor:
  host: https://${harbor_host}
  username: ${harbor_username}
  password: "${harbor_password}"
