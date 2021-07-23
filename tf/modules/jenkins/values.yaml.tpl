controller:
  ingress:
    enabled: true
    apiVersion: "extensions/v1beta1"
    hostName: ${jenkins_host}
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    %{if ingress_class != ""}
      kubernetes.io/ingress.class: ${ingress_class}
    %{endif}
       
rbac:
  readSecrets: true

serviceAccountAgent:
  name: jenkins-agent

persistence:
  size: 1Gi
