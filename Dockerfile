FROM arm32v6/golang:1.15-alpine3.12 AS builder

ENV GOPATH /go
WORKDIR /go/src

RUN mkdir -p /go/src/github.com/peteho/txwifi
COPY . /go/src/github.com/peteho/txwifi

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o /go/bin/wifi /go/src/github.com/peteho/txwifi/main.go

FROM arm32v6/alpine:3.12

RUN apk update
RUN apk add bridge hostapd wireless-tools wpa_supplicant dnsmasq iw

RUN mkdir -p /etc/wpa_supplicant/
COPY ./dev/configs/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

WORKDIR /

COPY --from=builder /go/bin/wifi /wifi
ENTRYPOINT ["/wifi"]


