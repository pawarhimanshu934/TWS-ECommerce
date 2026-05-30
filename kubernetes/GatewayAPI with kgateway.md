# Getting Started with kgateway

**API GATEWAY** - Replacement of Ingress  
**Gateway Controller:** kgateway

## Before You Begin

These quick start steps assume that you have:
- Kubernetes cluster
- kubectl
- helm

For quick testing, you can use Kind.

## Installation Steps

### 1. Deploy the Kubernetes Gateway API CRDs

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/latest/download/standard-install.yaml
```

### 2. Deploy the kgateway CRDs using Helm

```bash
helm upgrade -i kgateway-crds oci://cr.kgateway.dev/kgateway-dev/charts/kgateway-crds \
  --create-namespace \
  --namespace kgateway-system \
  --version v2.3.0-main \
  --set controller.image.pullPolicy=Always
```

### 3. Install kgateway using Helm

To use experimental Gateway API features, include the experimental feature gate:

```bash
helm upgrade -i kgateway oci://cr.kgateway.dev/kgateway-dev/charts/kgateway \
  --namespace kgateway-system \
  --version v2.3.0-main \
  --set controller.image.pullPolicy=Always \
  --set controller.extraEnv.KGW_ENABLE_GATEWAY_API_EXPERIMENTAL_FEATURES=true
```

### 4. Verify kgateway Control Plane

Make sure that the kgateway control plane is running:

```bash
kubectl get pods -n kgateway-system
```

**Example output:**

```
NAME                        READY   STATUS    RESTARTS   AGE
kgateway-5495d98459-46dpk   1/1     Running   0          19s
```

## Cleanup

No longer need kgateway? Uninstall with the following command:

```bash
helm uninstall kgateway -n kgateway-system
```
