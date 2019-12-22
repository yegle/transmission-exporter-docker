FROM golang:1.13-stretch as build_env
ARG SOURCE_BRANCH
ENV SOURCE_BRANCH=${SOURCE_BRANCH:-0.3.0}

RUN git clone https://github.com/metalmatze/transmission-exporter

WORKDIR /go/transmission-exporter/cmd/transmission-exporter
RUN git checkout -b temp ${SOURCE_BRANCH}
RUN CGO_ENABLED=0 go build .
RUN strip -s transmission-exporter

FROM gcr.io/distroless/static-debian10:nonroot

COPY --from=build_env /go/transmission-exporter/cmd/transmission-exporter/transmission-exporter /bin/transmission-exporter

WORKDIR /

ENTRYPOINT ["/bin/transmission-exporter"]
