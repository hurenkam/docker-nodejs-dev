# docker-fileserver
Debian Linux (v11 - bullseye) based Time Machine / Samba / NFS server

## To be supported: (work in progress)
- Time Machine backups from my Big Sur & Monterey machines
- Samba access from my Big Sur & Monterey machines
- Samba access from my Windows 10 & 11 machines
- NFS access from my Ubuntu 18.04 & 20.04 machines

## How to use this image:
Point your browser to localhost:9090 where you find a running cockpit instance
Using the Accounts section you can add linux user accounts, and subsequently
Using the File-Sharing section you should be able to add samba user passwords for those accounts
Now you should be able to add samba shares.
And in the NFS tab you should be able to add nfs shares.
  
### Typical command to run this image:
- docker run -d --privileged --net=host -v /exports:/exports hurenkam/fileserver:latest

### If you wish to run it on seperate network (note: avahi won't work then):
- docker run -d --privileged -v /exports:/exports -p 111:111 -p 137:137 -p 138:138 -p 445:445 -p 548:548 -p 2049:2049 -p 32765:32765 -p 32766:32766 -p 32767:32767 -p 32768:32768 hurenkam/fileserver:latest

## Credits:
Before i put this together, i studied docker & alpine documentation, as well as several other docker images. 
Some of the ideas and scripts in this image are based on these other images:
- https://hub.docker.com/r/mbentley/timemachine/
- https://hub.docker.com/r/kartoffeltoby/docker-nas-samba/
- https://hub.docker.com/r/fuzzle/docker-nfs-server/

To get debian working with systemd, i based it on these Dockerfiles:
- https://github.com/j8r/dockerfiles/blob/master/systemd/debian/11.Dockerfile
- https://github.com/alehaa/docker-debian-systemd/blob/master/Dockerfile

The cockpit-file-sharing plugin was taken from here:
- https://jsrepos.com/lib/45Drives-cockpit-file-sharing

