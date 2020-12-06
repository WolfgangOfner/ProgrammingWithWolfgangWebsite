---
title: Deploy to Kubernetes using Helm Charts
date: 2020-12-07
author: Wolfgang Ofner
categories: [Kubernetes]
tags: [Helm, AKS, Microservice]
---




## Deploy the Microservice with Helm
helm install customer customerapi

```yaml
image:
  repository: wolfgangofner/customerapi
  tag: latest
```

helm upgrade customer customerapi

```yaml
service:
  type: LoadBalancer
  port: 80
```

```powershell
kubectl get svc -w customerapi
```

```powershell
choco install kubernetes-helm
```

## Update a Helm Deployment



## Conclusion