rode:
  url: http://rode.${namespace}.svc.cluster.local:50052

image:
  tag: ${rode_ui_version}

ingress:
  enabled: true
  hosts:
    - host: ${rode_ui_host}
      paths:
        - "/"