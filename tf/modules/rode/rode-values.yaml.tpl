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
%{if rode_version != ""}
  tag: "${rode_version}"
%{endif}
