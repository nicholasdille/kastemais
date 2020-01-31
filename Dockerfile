FROM golang:1.13-alpine AS yaml-patch
RUN apk add --update-cache git \
 && go get -u github.com/krishicks/yaml-patch \
 && cd /go/src/github.com/krishicks/yaml-patch/cmd/yaml-patch \
 && go get . \
 && go build . \
 && mv yaml-patch /

FROM docker:stable AS base
RUN apk add --update-cache --no-cache \
        git \
        curl \
        ca-certificates \
        openssl \
        jq \
        gettext \
        bash

FROM base AS kustomize
RUN curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | \
        jq --raw-output '.assets[] | select(.name | endswith("_linux_amd64.tar.gz")) | .browser_download_url' | \
        xargs curl -sLf | \
        tar -xvzC /usr/local/bin/ kustomize

FROM base AS yq
RUN curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | \
        jq --raw-output '.assets[] | select(.name == "yq_linux_amd64") | .browser_download_url' | \
        xargs curl -sLfo /usr/local/bin/yq \
 && chmod +x /usr/local/bin/yq

FROM base AS final
COPY --from=yaml-patch /yaml-patch /usr/local/bin/
COPY --from=kustomize /usr/local/bin/kustomize /usr/local/bin/
COPY --from=yq /usr/local/bin/yq /usr/local/bin/
COPY . /kastemais/
WORKDIR /kastemais
CMD ["/bin/bash"]
