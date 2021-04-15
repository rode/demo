rode:
  url: http://rode.${namespace}.svc.cluster.local:50051

image:
  tag: ${rode_ui_version}

ingress:
  enabled: true
  %{if ingress_class != ""}
  annotations:
    kubernetes.io/ingress.class: ${ingress_class}
  %{endif}
  hosts:
    - host: ${rode_ui_host}
      paths:
        - "/"
