FROM golang:1.19.0-alpine3.16 as builder
WORKDIR /app
ADD . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -installsuffix cgo -o server main.go

FROM gcr.io/distroless/static as prod
ARG SERVER_PORT=3030
ENV SERVER_PORT=${SERVER_PORT}
COPY --from=builder /app/server /server
EXPOSE ${SERVER_PORT}
USER 1001
ENV GOMAXPROCS=4
CMD [ "/server" ]