FROM alpine:latest AS builder

# Install all dependencies required for compiling busybox
RUN apk add gcc musl-dev make perl

# Download busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

# Changing working directory
WORKDIR /busybox

# Copy the busybox build config (limited to httpd)
COPY .config .

# Downloading and unziping the CA1
RUN wget https://github.com/MatheusDevios/CA1/archive/main.zip
RUN unzip main.zip

# Compile and install busybox
RUN make && make install
# Create a non-root user to own the files and run our server
RUN adduser -D static

# Switch to the scratch image
FROM scratch

# exposing port 8080
EXPOSE 8080

# Copying user and custom BusyBox version to the scratch image
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /busybox/_install/bin/busybox /

# Use our non-root user
USER static
WORKDIR /home/static

COPY httpd.conf .

# Copy your static files
COPY html .

# Run busybox httpd
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf", "./index.html"]