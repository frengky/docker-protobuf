FROM golang:1.16-alpine AS go-builder

RUN go get google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
    ls -al /go/bin

FROM alpine:latest
LABEL maintainer="frengky.lim@gmail.com"

ARG GLIBC_VERSION=2.33-r0
ARG PROTOC_VERSION=3.15.3

RUN apk --update --no-cache add \
    grpc \
    wget && \
    wget -q https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O glibc.apk && \
    apk add glibc.apk && \
    rm -f /etc/apk/keys/sgerrand.rsa.pub glibc.apk && \
    wget -q https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip -O protoc.zip && \
    unzip protoc.zip -d /usr/local && \
    rm -f protoc.zip && \
    apk del wget && \
    rm -rf /var/cache/apk/*

COPY --from=go-builder /go/bin/protoc-gen-go /usr/local/bin/
COPY --from=go-builder /go/bin/protoc-gen-go-grpc /usr/local/bin/

VOLUME /app
WORKDIR /app

ENTRYPOINT [ "protoc", "-I=/usr/local/include", "-I=/app" ]
