controller:
   ingress:
       enabled: true
       apiVersion: "extensions/v1beta1"
       hostName: ${jenkins_host}
       %{if ingress_class != ""}
       annotations:
         kubernetes.io/ingress.class: ${ingress_class}
       %{endif}
