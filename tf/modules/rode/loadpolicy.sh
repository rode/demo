#!/bin/sh
curl --request POST \
  --url http://rode.rode-demo.svc.cluster.local:50052/v1alpha1/policies \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "test",
	"description": "this is the test",
	"rego_content":  "package realtest \n default pass = false\npass {\n  m := input.occurrences\n  m[i].resource.name == \"testing2\"\n}",
  "source_path": "http://abcdef.com"
}'