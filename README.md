# Rode Demo

This repository contains a demo / example of Rode's functionality.

Included in the repo is a `/tf` folder that includes the necessary Terraform automation to deploy the services required to run Rode.

Inside the `/app` folder, there is a sample hello-world node app based on an Alpine image with two known medium vulnerabilities that will build on a deployed Jenkins CI server. 

Simply change the base image in the Dockerfile to `node:current-alpine3.12`, to resolve the vulnerabilities.


## Prerequisites

- Terraform >= 0.13.0
- Terragrunt
- A Kubernetes cluster (the cluster that comes with Docker Desktop for Mac is recommended)

## Usage

### Local Setup

For local access to Jenkins and Harbor through the created ingress, new entries need to be created inside your local hosts file.
```
sudo vi /etc/hosts
```

Copy and paste the two lines below to your /etc/hosts file.
```
127.0.0.1 harbor.localhost
127.0.0.1 jenkins.localhost
```
---
Additionally, a rewrite may need to be added to your clusters DNS server to send Harbor traffic through the nginx controller. Automation is in place to update the CoreDNS configmap to include this rewrite, but in the event of a failed image deployment to Harbor inside the cluster, you may look to add the rewrite show below in the data block.

```
rewrite name harbor.localhost ingress-nginx-controller.nginx.svc.cluster.local
```

![rewrite](img/rewrite.png)

---

To deploy the Rode stack locally, switch to the `tf` directory, then run

```
terragrunt apply-all
```

---

## Retrieving Credentials

### Jenkins admin password

To retrieve the Jenkins admin password for authentication use the command below to copy it to your clipboard.

```
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode | pbcopy
```

### Harbor admin password

To retrieve the Harbor admin password for authentication use the command below to copy it to your clipboard.

```
kubectl get secret -n harbor harbor-harbor-core -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 --decode | pbcopy
```