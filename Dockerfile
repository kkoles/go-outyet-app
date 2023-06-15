##################################################
# Build the app
##################################################

FROM golang:1.15 as builder

WORKDIR /go/src/app

# Download Go modules.
COPY go.mod ./
RUN go mod download

# Copy the source code.
COPY *.go ./

RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

##################################################
# Copy the app to distroless image
##################################################

FROM gcr.io/distroless/static-debian11:nonroot

COPY --from=builder /go/bin/app /

# This is for documentation purposes only. 
# For actual port opening, runtime port parameters should be provided.
EXPOSE 8080

CMD ["/app"]