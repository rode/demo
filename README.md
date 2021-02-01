# Rode Demo

This repository contains a demo / example of Rode's functionality.

Included in the repo is a `/tf` folder that includes the necessary Terraform automation to deploy the services required to run Rode.

Inside the `/app` folder, there is a sample hello-world node app based on an Alpine image with two known medium vulnerabilities that will build on a deployed Jenkins CI server. 

Simply change the base image in the Dockerfile to `node:current-alpine3.12`, to resolve the vulnerabilities.


## Prerequisites

- Terraform >= 0.13.0
- Terragrunt
- A Kubernetes cluster (the cluster that comes with Docker Desktop for Mac is recommended)
- kubectl

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
Additionally, a rewrite may need to be added to your clusters DNS server to send Harbor traffic through the nginx controller. Automation is in place to update the CoreDNS configmap to include this rewrite, but in the event of a failed image deployment to Harbor inside the cluster, you may look to add the rewrite show below in the data block. (If your cluster is
not using CoreDNS, you can disable this automation by setting the variable `update_coredns`
to false. You will need to find another way to direct traffic to Harbor.)

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

## Configuring Harbor

Some manual setup for Harbor is required after Harbor has been deployed. You can log in with the `admin` user using
the credentials you obtained in the previous section to do this.

After logging in, navigate to the "library" project. In the "Configuration" tab, check the box labeled "Automatically scan
images on push", then save your changes.

Next, navigate to the "Webhooks" tab, and add a new webhook with the following settings:
- Name: You can set this to any string you want
- Notify Type: `http`
- Event Type:
  - [x] `Artifact Pushed`
  - [x] `Scanning Finished`
  - [x] `Scanning Failed`
- Endpoint URL: `http://rode-collector-harbor.rode-demo.svc.cluster.local/webhook/event`

## Pushing Images To Harbor

When running locally using an auto-generated certificate for Harbor, you will need to add Harbor as an [insecure Docker registry](https://docs.docker.com/registry/insecure/).

Before pushing an image, you will need to log in to Harbor using the Docker CLI:
```bash
$ docker login harbor.localhost -u admin -p ${admin_password}
```

Then, you can push an image using `docker push`. We recommend pulling an existing image, tagging it, then pushing it to Harbor:
```bash
$ docker pull alpine:latest
$ docker tag alpine:latest harbor.localhost/library/alpine:latest
$ docker push harbor.localhost/library/alpine:latest
```
