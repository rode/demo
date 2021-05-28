rode:
  host: ${rode_host}
  insecure: true

harbor:
  host: ${harbor_url}
  username: ${harbor_username}
  insecure: ${harbor_insecure}

debug: true

image:
%{~ if harbor_collector_version != "" }
  tag: "${harbor_collector_version}"
%{~ endif }
