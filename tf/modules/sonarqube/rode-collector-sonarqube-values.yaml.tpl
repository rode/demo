rode:
  host: ${rode_host}
  insecure: true

debug: true

image:
%{~ if sonarqube_collector_version != "" }
  tag: "${sonarqube_collector_version}"
%{~ endif }
