FROM golang:1.15-buster

RUN apt-get update -y && \
    apt-get install -y libbtrfs-dev libseccomp-dev git wget unzip

ENV GOPATH=/go

RUN wget -c https://github.com/google/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip

RUN unzip protoc-3.11.4-linux-x86_64.zip -d /usr/local && \
    rm protoc-3.11.4-linux-x86_64.zip

RUN go get github.com/containerd/containerd

RUN mkdir -p /ctrconfig

COPY config.toml /ctrconfig

WORKDIR /go/src/github.com/containerd/containerd

RUN make && \
    make install

RUN rm -rf /go/src/github.com/containerd/containerd

ENTRYPOINT [ "containerd" ]

CMD ["--config", "/ctrconfig/config.toml"]