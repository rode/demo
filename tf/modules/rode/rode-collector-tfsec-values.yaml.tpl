rode:
  host: rode.${namespace}.svc.cluster.local:50051
  insecure: true

debug: true

image:
%{~ if tfsec_collector_version != "" }
  tag: "${tfsec_collector_version}"
%{~ endif }
