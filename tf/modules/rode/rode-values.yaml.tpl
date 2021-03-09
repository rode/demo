grafeas-elasticsearch:
  enabled: false

rode-ui:
  enabled: false

grafeas:
  host: "grafeas-server.${grafeas_namespace}.svc.cluster.local:8080"

elasticsearch:
  host: http://${elasticsearch_host}

debug: true

image:
  tag: "v0.1.0"
