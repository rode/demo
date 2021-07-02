ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 32m
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
  %{~ if ingress_class != ""}
    kubernetes.io/ingress.class: ${ingress_class}
  %{~ endif}
  hosts:
    - name: ${host}
      path: "/"

sonarProperties:
  "sonar.core.serverBaseURL": "http://${host}"
