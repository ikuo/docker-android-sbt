# docker-android-sbt
A Dockerfile to build and launch Android apps by sbt.

## Requirements
- Android SDK installed on a host machine (docker client)

## Usage

Assume that you have host ssh keys at `~/.ssh/id_rsa`.

Run the image with your public key authorized:
```
$ docker run -it --rm -p 7022:22 ikuo/android-sbt "`cat ~/.ssh/id_rsa.pub`"
```

If you are using boot2docker (in Mac OS), make sure to forward the port host:7022 to boot2docker-vm:7022.

Then forward port of adb-server that container:5037 to host:5037 as follows:

```
$ ssh ubuntu@localhost -p 7022 -R 5037:localhost:5037
```

Start Android emulator or connect device via USB on the host machine.
Then this emulator or device is available in the docker container:

```
ubuntu@xxxxxxxxxx:~$ adb devices
List of devices attached
358673041154495 device
```
