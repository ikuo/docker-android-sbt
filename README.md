# docker-android-sbt
A Dockerfile to build and launch Android apps by sbt.

## Requirements
- Android SDK installed on the host machine

## Usage

Setup ssh keys:
```
$ cat ~/.ssh/id_rsa.pub > ssh/authorized_keys
$ ssh-keygen -t rsa -n 1024 -N "" -f ssh/id_rsa
```

Build an image:
```
$ docker build -t <user-name>/android-sbt .
```

Run it:
```
$ docker run -it --rm -p 7022:22 <user-name>/sbt-android-login
```

Forward container:5037 to host machine:5037:
```
$ ssh ubuntu@localhost -i ~/.ssh/id_rsa -p 7022 -R 5037:localhost:5037
```

If you use boot2docker (in Mac OS), make sure forward the port 7022 to boot2docker-vm:7022.
