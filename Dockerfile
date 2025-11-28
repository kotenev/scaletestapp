FROM golang:1.22-alpine AS build
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /bin/app

FROM scratch
COPY --from=build /bin/app /bin/app

EXPOSE 8080
ENTRYPOINT ["/bin/app"]