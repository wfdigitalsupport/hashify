# STEP 1 build executable binary
FROM golang:alpine as builder

LABEL maintainer "Darwin Smith II <172265+dwin@users.noreply.github.com>"
LABEL app_version="0.1.0" architecture="amd64"

COPY /app $GOPATH/src/github.com/dwin/hashify/app
WORKDIR $GOPATH/src/github.com/dwin/hashify/app
#get dependancies
#you can also use dep
RUN go install golang.org/dl/go1.10.7@latest
#RUN go get -d -v

#build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/hashify

# STEP 2 build a small image
# start from scratch
FROM scratch
# Copy our static executable
COPY --from=builder /go/bin/hashify /go/bin/hashify
EXPOSE 1313
ENTRYPOINT ["/go/bin/hashify"]

# docker build . -t dwin/hashify:0.1.0
# docker push dwin/go-hashify:0.1.0
# docker run -d -p 1313:1313 --name hashify dwin/hashify:0.1.0

# docker run -d --name api dwin/hashify
