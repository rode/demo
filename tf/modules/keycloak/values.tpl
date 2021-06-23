serviceAccount:
  name: keycloak

extraVolumeMounts: |
  - name: creds
    mountPath: /secrets/creds
    readOnly: true

extraVolumes: |
  - name: creds
    secret:
      secretName: ${keycloak_secret}

extraEnv: |
  - name: PROXY_ADDRESS_FORWARDING
    value: "true"
  - name: KEYCLOAK_USER_FILE
    value: /secrets/creds/admin_username
  - name: KEYCLOAK_PASSWORD_FILE
    value: /secrets/creds/admin_password
  - name: KEYCLOAK_LOGLEVEL
    value: "INFO"


ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "${ingress_class}"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  rules:
  - host: ${ingress_hostname}
    paths:
      - /
  tls:
  - hosts:
    - ${ingress_hostname}
  path: /

resources:
  requests:
    memory: 600Mi
    cpu: 50m
  limits:
    memory: 800Mi
    cpu: 1

postgresql:
  resources:
    requests:
      memory: 64Mi
      cpu: 10m
    limits:
      memory: 128Mi
      cpu: 500m