# kastemais

Templating similar to kustomize but with multiple overlays

## Install prerequisites

```bash
docker build --tag kastemais .
```

## Design

XXX

An application describes the minimum to deploy a service

An overlay contains YAML patches that modify an application with a specific purpose, e.g.

- Adding namespace
- Adding labels and annotations
- Adding resources
- Adding sidecars

### Applications

Stored in a subdirectory of `/app`, e.g. `/app/nginx`

Contains one or more YAML documents in one or more files - multiple documents per file a allowed

All files must have a leading document separator `---`

### Overlays

Stored in a subdirectory if `/overlay`, e.g. `/overlay/sidecar-monitoring`

Overlays can be applied to all documents

Overlays can be applied to specific documents using filters

## Building blocks

### Reading a value from YAML

```bash
cat app/nginx/deployment.yaml | docker run -i kastemais yq r - metadata.name
```

### Apply YAML patch

```bash
cat app/nginx/deployment.yaml | docker run -i kastemais yaml-patch -o overlay/ci-annotations/patch-all.yaml
```

This also works for multiple documents:

```bash
cat app/nginx/*.yaml | docker run -i kastemais yaml-patch -o overlay/ci-annotations/patch-all.yaml
```

### Add prefix/suffix

```bash
NAME=$(./yq r app/nginx/deployment.yaml metadata.name)
cat app/nginx/deployment.yaml | docker run -i kastemais yq w - metadata.name ${NAME}-qa
```

### Filter documents

TODO: How to filter?

TODO: Merge into one YAML document?

```yaml
apiVersion: v1beta3
kind: List
items:
- ...
- ...
```

TODO: How to merge?

This is also valid:

```yaml
apiVersion: v1
kind: List
items:
-
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: nginx
  data:
    index.html: |
      <html>
      <head><title>Test</title></head>
      <body><h1>Test</h1>Test</body>
      </html>
-
  apiVersion: v1
  kind: Service
  metadata:
    name: nginx
  spec:
    selector:
      app: nginx
    ports:
      - protocol: TCP
        port: 80
        targetPort: 80

```

Select document based on `kind`:

```yaml
---
- op: add
  path: /items/kind=Deployment/spec/template/spec/containers/-
  value:
    name: telegraf
    image: telegraf
```
