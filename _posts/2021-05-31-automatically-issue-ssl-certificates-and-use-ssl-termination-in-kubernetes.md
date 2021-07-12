---
title: Automatically issue SSL Certificates and use SSL Termination in Kubernetes 
date: 2021-05-31
author: Wolfgang Ofner
categories: [Kubernetes, Cloud]
tags: [DevOps, Azure DevOps, Azure, Nginx, YAML, CI-CD, Docker, Helm, AKS, Kubernetes, TLS, SSL]
description: Users expect HTTPS connection. Cert-manager can be used to automatically issue SSL certificates to your applications running in Kubernetes.
---

[In my last post](/configure-custom-urls-to-access-microservices-running-in-kubernetes), I created an Nginx ingress controller and assigned different URLs to its public URL. The Nginx controller analyses the URL and routes the traffic automatically to the right application. The solution presented worked but only used HTTP. Nowadays, browsers show a warning when not using HTTPS and users also expect to have secure connections.

This post will show you how to configure a cert-manager and automatically issue certificates for your applications.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).

## Install Cert-Manager

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

Cert-Manager is a Kubernetes add-on that issues automatically TLS certificates for your applications. You can find it on <a href="https://github.com/jetstack/cert-manager" target="_blank" rel="noopener noreferrer">Github</a>. To install the cert-manager using Helm charts, execute the following commands:

```shell
kubectl label namespace ingress-basic cert-manager.io/disable-validation=true

helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace ingress-basic \
  --set installCRDs=true \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set webhook.nodeSelector."kubernetes\.io/os"=linux \
  --set cainjector.nodeSelector."kubernetes\.io/os"=linux
```

I use the ingress-basic namespace also for Nginx. If you want, use a different one for the cert-manager.

## Install a Let's Encrypt Certificate Issuer

After installing the cert-manager, install a certificate issuer to generate the tls certificates for your applications.

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: <Your Email>
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: nginx
          podTemplate:
            spec:
              nodeSelector:
                "kubernetes.io/os": linux
```

Save the code in a file and then apply the file to your Kubernetes cluster, 

```bash
kubectl apply -f cluster-issuer.yaml
```

This example uses Let's Encrypt as issuer but you can use any CA issuer you want. Before you deploy the code, add your email so you can get emails about the certificates. At the beginning of the code, you can see the kind of object is ClusterIssuer. A ClusterIssuer can create certificates for all applications, no matter in what namespace they are. The second option is Issuer which works only in a single namespace. An issuer might be useful if you want to use a different CA issuer.

## Update the Microservices to use the TLS Certificate

There is not much to update in the configuration of the microservice to use the TLS secret. All you have to do is add the TLS secret and the host before the rules section in the ingress.yaml file of each microservice. The ingress.yaml file is part of the Helm chart. If you don't know Helm, see my posts [Helm - Getting Started](/helm-getting-started) and [Deploy to Kubernetes using Helm Charts](/deploy-kubernetes-using-helm).

The ingress.yaml file looks as follows:

{% raw %}
```yaml
{{- if .Values.ingress.enabled -}}
{{- $ingressPath := .Values.ingress.path -}}
{{- $pathType := .Values.ingress.pathType -}}
{{- $fullName := include "customerapi.fullname" . -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.namespace }}
  namespace: {{ .Values.ingress.namespace }}
{{- with .Values.ingress.annotations }}
  annotations:
{{ toYaml . | indent 4 }}
{{- end }}
spec:
{{- if .Values.ingress.tls }}
  tls:
  {{- range .Values.ingress.tls }}
    - hosts:
      {{- range .hosts }}
        - {{ . }}
      {{- end }}
      secretName: {{ .secretName }}
  {{- end }}
{{- end }}
  rules: 
  {{- range .Values.ingress.hosts }}
  - host: {{ . }}
    http:
      paths:
      - path: {{ $ingressPath }}
        pathType: {{ $pathType }}
        backend:
          service:
            name: {{ $fullName }}
            port: 
              number: 80
  {{- end }}
{{- end }}
```
{% endraw %}

The OrderApi ingress file looks the same, except that the name is orderapi instead of customerapi.

Next, add the TLS secret name and the host to the values.release.yaml or values.yaml file.

```yaml
hosts:
  - __URL__
tls:
  - secretName: __TlsSecretName__
    hosts:
      - __URL__
```
The variables, for example, \_\_TlsSecretName\_\_ are defined in the CI/CD pipeline and will be replaced by the tokenizer. For more information about the tokenizer, see [Replace Helm Chart Variables in your CI/CD Pipeline with Tokenizer](/replace-helm-variables-tokenizer).

```yaml
TlsSecretName: customerapi-tls
```

You can use whatever name you want for the TLS secret.

The last step is to add an additional annotation to the ingress of the microservice. Add the following line to the annotations section of the values.yaml or values.release.yaml file:

```yaml
cert-manager.io/cluster-issuer: letsencrypt
```
This is all you have to configure to automatically use HTTPS and also use SSL termination in the Nginx ingress controller. This means that the traffic inside the cluster uses only HTTP and therefore doesn't use any compute power to decrypt the connection.

## Using HTTPS to access the Microservice

Deploy the Microservice and then call their URL, in my case, customer.programmingwithwolfgang.com. You should see that HTTPS is used and that a valid certificate is used.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/A-valid-SSL-Certificate-got-created.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/A-valid-SSL-Certificate-got-created.jpg" alt="A valid SSL Certificate got created" /></a>
  
  <p>
   A valid SSL Certificate got created
  </p>
</div>

## Troubleshooting

If something did go wrong, you might see a warning when you try to access the microservice using HTTPS.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-SSL-Certificate-is-not-valid.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-SSL-Certificate-is-not-valid.jpg" alt="The SSL Certificate is not valid" /></a>
  
  <p>
   The SSL Certificate is not valid
  </p>
</div>

If you see this message, check if you added the letsencrypt annotation. I forget this one almost always. If this didn't fix the problem check if there is a certificate in your namespace with the following command:

```shell
kubectl get certificate --namespace customerapi-test
```

This should display your certificate.

<div class="col-12 col-sm-10 aligncenter">
  <a href="/assets/img/posts/2021/05/The-SSL-Certificate-got-added-to-the-Namespace.jpg"><img loading="lazy" src="/assets/img/posts/2021/05/The-SSL-Certificate-got-added-to-the-Namespace.jpg" alt="The SSL Certificate got added to the Namespace" /></a>
  
  <p>
   The SSL Certificate got added to the Namespace
  </p>
</div>

## Conclusion

A cert-manager creates SSL certificates automatically in your Kubernetes cluster and helps you to reduce the time to fully configure your application. This is especially useful when you use multiple test environments.

[In my next post](/split-up-the-ci-cd-pipeline-into-two-pipelines), I will show you how to separate the CI/CD pipeline into two pipelines which will enable you to make changes faster and with less errors.

You can find the code of the demo on <a href="https://github.com/WolfgangOfner/MicroserviceDemo" target="_blank" rel="noopener noreferrer">Github</a>.

This post is part of ["Microservice Series - From Zero to Hero"](/microservice-series-from-zero-to-hero).