FROM golang:latest AS builder

RUN apt-get update && \
    apt-get install git && \
    git clone --depth 1 --branch cf-delegated-credentials https://github.com/cloudflare/go /cf-go

WORKDIR /cf-go/src
RUN ./make.bash

FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y net-tools tcpdump ethtool iproute2

COPY --from=builder /cf-go /cf-go

COPY runner.go /

RUN /cf-go/bin/go build -o /usr/bin/runner runner.go

COPY setup.sh /
RUN chmod +x /setup.sh

COPY run_endpoint.sh /
RUN chmod +x /run_endpoint.sh

ENTRYPOINT [ "/run_endpoint.sh" ]
