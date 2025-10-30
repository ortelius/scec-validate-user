FROM cgr.dev/chainguard/go@sha256:5629318daea4e10361f7e257a1c81146f185b13ab35e7de6bba5b1417c48a0a4 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:9ef5c084ad7fedad78f7d33c7b5b686b13cc6c9a48342205b2490699797b9796

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
