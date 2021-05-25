# Args
ARG        ALPINE_VERSION=3.13
ARG        GOLANG_VERSION=1.16.4

# Builder image
FROM       golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as builder
ARG        VERSION=v0.1.0

# Package dependencies
WORKDIR    /go/src/app
COPY       go.* ./
RUN        go mod download

# Copy source and build
COPY       *.go ./
RUN        CGO_ENABLED=0 GOOS=linux go build \
             -a \
             -installsuffix cgo \
             -ldflags "-X main.version=${VERSION}" \
             -trimpath \
             .

# Final image - Will use alpine rather than scratch so we can troubleshoot
FROM       alpine:${ALPINE_VERSION}

# Lets include curl and netcat - helps with debugging until we have k8s debug containers on all k8s versions
RUN        apk --no-cache add ca-certificates curl netcat-openbsd
COPY       --from=builder /go/src/app/ktsg-argocd-demo /usr/local/bin/

EXPOSE     5000

# nobody:nobody, will use Ids so k8s deployments can match
USER       65534:65534

ENTRYPOINT ["/usr/local/bin/ktsg-argocd-demo"]
