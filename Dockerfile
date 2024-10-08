FROM cgr.dev/chainguard/go@sha256:acef75e26dece8460e7c4bdb87b7b7b71685d809f391ec3814d2182e98d1a937 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:7fa43737be034509a394129d6966fbb7fbb6cbc01f34ec03486f4acd5d657edc

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]
