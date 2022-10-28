# cbwa-ca1-matheus-diniz

CA1 of Cloud Based Web Application.
Name: Matheus Costa Diniz
Student number: 2022042

## Download

First download the repository to be able to proceed with it.

## Usage

Build the image:

```sh
docker build -t cbwa-ca1-matheus-diniz .
```

Run the image on port 8080:

```sh
docker run -it --rm -p 8080:8080 cbwa-ca1-matheus-diniz
```

Browse to `http://localhost:8080`.

**NOTE:** To be able to run the CA project direclty form GitHub was added the following lines:

```dockerfile
# Copying the content of Web CA1 to the scratch image
COPY --from=builder /home/static /home/static

## Changing working directory to /home/static/web_ca1-main
WORKDIR /home/static/webdev_ca1-main
```

## After the container runs, it executes busybox, httpd and so on.

```dockerfile
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]
```

**NOTE:** .dockerignore and .gitignore files are added in order no to add some files to the container when runing and to the git repository respectively.

## httpd.conf changes if nedded to allow or deny id/rules for the container

Add to `httpd.conf` file and use the `P` directive:

```
P:/some/old/path:[http://]hostname[:port]/some/new/path
```

### If you want to overide the default error page

Add to the `httpd.conf` file and use the `E404` directive:

```
E404:e404.html
```

...where `e404.html` is your custom 404 page.

Note that the error page directive is only processed for your main `httpd.conf` file. It will raise an error if you use it in `httpd.conf` files added to subdirectories.

### Implement basic security measures in your image.

Add to `httpd.conf` file and use the `A` and `D` directives:

```
A:172.20.         # Allow address from 172.20.0.0/16
A:10.0.0.0/25     # Allow any address from 10.0.0.0-10.0.0.127
A:127.0.0.1       # Allow local loopback connections
D:*               # Deny from other IP connections
```

You can also allow all requests with some exceptions:

```
D:1.2.3.4
D:5.6.7.8
A:* # This line is optional
```

### use basic auth for some of my paths?

Add a `httpd.conf` file, listing the paths that should be protected and the corresponding credentials:

```
/admin:my-user:my-password # Require user my-user with password my-password whenever calling /admin
```

## References

### Initial reference to start the project and know how to proced with it:

- https://github.com/lipanski/docker-static-website

### Fetching the latest version of Alpine as a base image:

- https://docs.docker.com/engine/reference/builder/#from

### Changing working directory:

- https://www.java4coding.com/contents/docker/docker-workdir-command

### Creating a new user to secure running commands:

- https://www.unix.com/man-page/minix/8/adduser/

### Switching to the scratch image:

- https://www.devopsschool.com/blog/creating-a-simple-parent-base-docker-image-using-scratch/

### Switching to user static from the root

- https://www.java4coding.com/contents/docker/docker-user-command

### How to download an use wget:

- https://gist.github.com/jwebcat/5122366
