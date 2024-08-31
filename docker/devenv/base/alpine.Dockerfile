# syntax=docker/dockerfile:experimental
ARG GITLAB_DEPENDENCY_PROXY_PATH=mau.dev/andreijiroh-dev
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/golang:alpine as golang
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/alpine:edge as base

COPY --from=golang /usr/local/go/ /usr/local/go/
ENV PATH=/usr/local/go/bin:/go/bin:$PATH GOPATH=/go
RUN mkdir /go && go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest