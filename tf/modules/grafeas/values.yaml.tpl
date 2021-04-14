grafeas:
  elasticsearch:
    url: ${elasticsearch_url}
    username: ${elasticsearch_username}
    password: ${elasticsearch_password}
    refresh: "true"
curl: {}
elasticsearch:
  enabled: false

image:
  tag: "${grafeas_version}"
