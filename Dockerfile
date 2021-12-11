# Build stage
ARG GO_VERSION=1.16
ARG ALPINE_VERSION=3.15

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} as build

ENV CGO_ENABLED=0

WORKDIR /app
COPY /app .
RUN go build -o build/dude

# Deploy stage
FROM alpine:${ALPINE_VERSION}

WORKDIR /app
COPY --from=build /app/build .
EXPOSE 8080
ENTRYPOINT ["./dude"]
