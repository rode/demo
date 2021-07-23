ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 32m
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  %{~ if ingress_class != ""}
    kubernetes.io/ingress.class: ${ingress_class}
  %{~ endif}
  hosts:
    - name: ${host}
      path: "/"
  tls:
    - hosts:
        - ${host}

sonarProperties:
  "sonar.core.serverBaseURL": "https://${host}"
  "sonar.log.level": "DEBUG"

postgresql:
  resources:
    requests:
      memory: 64Mi
      cpu: 10m
    limits:
      memory: 128Mi
      cpu: 500m
  persistence:
    size: 1Gi
