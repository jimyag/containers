FROM golang:alpine AS builder

ARG VERSION=latest
RUN go install tailscale.com/cmd/derper@${VERSION}

FROM alpine:latest AS derper
WORKDIR /app

RUN apk update && \
    apk add --no-cache ca-certificates && \
    mkdir /app/certs

ENV HOSTNAME=
ENV CERTMODE=letsencrypt
ENV CERTDIR=/app/certs
ENV SERVER_ADDR=:443
ENV STUN=true
ENV STUN_PORT=3478
ENV HTTP_PORT=80
ENV VERIFY_CLIENTS=false
ENV VERIFY_CLIENT_URL=

COPY --from=builder /go/bin/derper .

ENTRYPOINT [ "/app/derper" ]
CMD --hostname=$HOSTNAME \
    --certmode=$CERTMODE \
    --certdir=$CERTDIR \
    --a=$SERVER_ADDR \
    --stun=$STUN  \
    --stun-port=$STUN_PORT \
    --http-port=$HTTP_PORT \
    --verify-clients=$VERIFY_CLIENTS \
    --verify-client-url=$VERIFY_CLIENT_URL
