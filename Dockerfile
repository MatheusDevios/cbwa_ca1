FROM alpine:3.13.2 AS builder

# Install all dependencies required for compiling busybox
RUN apk add gcc musl-dev make perl

# Download busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

WORKDIR /busybox

# Copy the busybox build config (limited to httpd)
COPY .config .

# Compile and install busybox
RUN make && make install
# Create a non-root user to own the files and run our server
RUN adduser -D static

# Switch to the scratch image
FROM scratch

EXPOSE 8080