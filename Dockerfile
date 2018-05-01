FROM golang:1.9 as builder
RUN bash -c "curl https://glide.sh/get | sh"
WORKDIR /go/src/github.com/stellar/go

COPY glide.lock glide.yaml ./
RUN glide install

COPY . .
RUN go install github.com/stellar/go/services/horizon

FROM alpine:latest

COPY --from=builder /go/bin/horizon /usr/local/bin/horizon

EXPOSE 8000

ADD entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["horizon"]
