FROM golang:1.12.9

RUN apt-get update && apt-get install -y --no-install-recommends \
                openssh-client \
                rsync \
                fuse \
                sshfs \
        && rm -rf /var/lib/apt/lists/*

RUN go get  golang.org/x/lint/golint \
            github.com/mattn/goveralls \
            golang.org/x/tools/cover

ENV USER root
WORKDIR /go/src/github.com/docker/machine

COPY . ./
RUN mkdir bin

RUN make clean
RUN make build

RUN sha256sum bin/docker-machine
# For simpler copying path, put it in root /bin
RUN cp bin/docker-machine /bin/docker-machine
