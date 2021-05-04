ingress:
  enabled: true
  annotations:
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

account:
  adminPassword: "${admin_password}"
