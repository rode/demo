rode:
  host: rode.${namespace}.svc.cluster.local:50051
  disableTransportSecurity: true

debug: true

image:
%{~ if build_collector_version != "" }
  tag: "${build_collector_version}"
%{~ endif }
