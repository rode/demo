replicas: ${replicas}

resources:
  requests:
    cpu: "100m"
    memory: "512M"
  limits:
    cpu: "1000m"
    memory: "1Gi"

esJavaOpts: "-Xmx512m -Xms512m"

extraEnvs:
  - name: ELASTIC_USERNAME
    valueFrom:
      secretKeyRef:
        name: ${elasticsearch_credentials_secret_name}
        key: username
  - name: ELASTIC_PASSWORD
    valueFrom:
      secretKeyRef:
        name: ${elasticsearch_credentials_secret_name}
        key: password
