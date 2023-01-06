# docker-nodejs-dev
Debian Linux (v11 - bullseye) based remote development server for nodejs

## How to use this image:
Point your browser to localhost:9090 where you find a running cockpit instance
Using the Accounts section you can add linux user accounts.
  
### Typical command to run this image:
- docker run -d --privileged docker.io/hurenkam/debian-nodejs-dev:latest

## Credits:
To get debian working with systemd, i based it on these Dockerfiles:
- https://github.com/j8r/dockerfiles/blob/master/systemd/debian/11.Dockerfile
- https://github.com/alehaa/docker-debian-systemd/blob/master/Dockerfile

