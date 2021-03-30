controller:
   ingress:
       enabled: true
       apiVersion: "extensions/v1beta1"
       hostName: ${jenkins_host}
       annotations: {
           kubernetes.io/ingress.class: nginx
       }
