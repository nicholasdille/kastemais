# kastemais

Templating similar to kustomize but with multiple overlays

## Install prerequisites

This requires [`yq`](https://github.com/mikefarah/yq) and [`yaml-patch`](https://github.com/krishicks/yaml-patch)

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

Merge into one YAML document in the form (see `merge_documents()` in `functions.sh`):

```yaml
apiVersion: v1
kind: List
items:
- ...
- ...
```

This is also valid:

```yaml
apiVersion: v1
kind: List
items:
-
  ...
-
  ...
```

### Handling multiple documents

`yq` can only operate on numerically indexed documents in a file:

```bash
$ cat app/nginx/*.yaml | yq3 -d'*' r - kind
ConfigMap
Deployment
Service
```

`yq` can also merge multiple documents within a file when in the correct order (see `merge_documents()` in `functions.sh`)

Workaround: Split documents into separate files

```bash
$ cat app/nginx/*.yaml | csplit --prefix=document- --suffix-format=%02d.yaml --elide-empty-files --quiet - /---/ '{*}'
$ ls -l document-*.yaml
document-00.yaml  document-01.yaml  document-02.yaml
```

### Package definition

TODO: Description which application from `/app` and which overlays from `/overlay` to apply.

### Variable substitution

TODO: Is this in scope? If so...

- Support substitution from environment variables
- Explicit list of variables to substitute
- Support `.env` file?

Workaround: `envsubst`
