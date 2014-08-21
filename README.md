# docker-android-sbt
A Dockerfile to build and launch Android apps by sbt.

## Requirements
- Android SDK installed on the host machine

## Usage

Run the image
```
$ docker run -it --rm -p 7022:22 <user-name>/android-sbt
```

If you use boot2docker (in Mac OS), make sure forward the port 7022 to boot2docker-vm:7022.

```
$ ssh ubuntu@localhost -p 7022 -R 5037:localhost:5037
```
