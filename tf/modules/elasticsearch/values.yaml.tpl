replicas: 1

resources:
  requests:
    cpu: "100m"
    memory: "512M"
  limits:
    cpu: "1000m"
    memory: "512M"

esJavaOpts: "-Xmx128m -Xms128m"

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
