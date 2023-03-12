# K8s Cluster Additional Steps

## Adding the ingress

Go to [ingress documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)
and follow the instructions. To reduce the time we will show you the config at this time:
Scroll down until the [wildcards section](https://kubernetes.io/docs/concepts/services-networking/ingress/#hostname-wildcards)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: your-app-name
spec:
  rules:
  - host: "foo.bar.com"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: your-app-service-name
            port:
              number: 80
```

This is not enough to get the ingress working. You need an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

In our case we selected the [Nginx Ingress Controller](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme)
And we followed the [documentation to install the controller in AWS](https://kubernetes.github.io/ingress-nginx/deploy/#aws)

Basically:
```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml
```

## Adding the Cert Manager
This is necessary to issue new TLS certificates and renew them automatically.

Go to: https://cert-manager.io/docs/installation/kubectl/

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
```

### Adding the ACME issuer

Now go to the configuration section and configure the Basic ACME Issuer
https://cert-manager.io/docs/configuration/acme/

Add the following to the cluster, we have modified it to use production ready certificates
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
```

Use this to have an issuer for staging
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging 
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
```