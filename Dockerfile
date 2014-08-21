FROM ubuntu:14.04
MAINTAINER Ikuo Matsumura <makiczar@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://ja.archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install wget ssh -y --no-install-recommends

# Install Java6
RUN apt-get install software-properties-common -y --no-install-recommends # for add-apt-repository
RUN add-apt-repository ppa:webupd8team/java && apt-get update
## **** Make sure you agree the Oracle License ***
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections &&\
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get install oracle-java6-installer -y --no-install-recommends

# Install sbt
RUN wget http://dl.bintray.com/sbt/debian/sbt-0.13.5.deb && \
  dpkg -i sbt-0.13.5.deb
RUN apt-get update && apt-get install sbt

# Make user 'ubuntu'
RUN useradd ubuntu -m -g sudo && passwd -d ubuntu
RUN cd /home/ubuntu && sudo -H -u ubuntu sbt exit

# Install dependencies of Android SDK: https://hirooka.pro/?p=5905
# Downgrading libc6 2.19-0ubuntu6{.1 -> } to workaround unmet dependencies on dpkg.
RUN apt-get install build-essential libc-dev libc6=2.19-0ubuntu6 libc6-dev g++ -y --force-yes
RUN apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 -y
RUN apt-get install g++-multilib -y

# Configure sshd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo 'UseDns no' >> /etc/ssh/sshd_config
EXPOSE 22

# ---- Run as ubuntu user ----
USER ubuntu
WORKDIR /home/ubuntu
ENV HOME /home/ubuntu
RUN mkdir $HOME/opt/

# Install Android SDK, NDK, Ant {{{
#   https://registry.hub.docker.com/u/ahazem/android/dockerfile/
RUN wget http://dl.google.com/android/android-sdk_r22.3-linux.tgz
RUN wget http://dl.google.com/android/ndk/android-ndk-r9c-linux-x86_64.tar.bz2
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz

RUN tar -xvzf android-sdk_r22.3-linux.tgz && \
  mv android-sdk-linux $HOME/opt/android-sdk
RUN tar -xvjf android-ndk-r9c-linux-x86_64.tar.bz2 && \
  mv android-ndk-r9c $HOME/opt/android-ndk
RUN tar -xvzf apache-ant-1.8.4-bin.tar.gz && \
  mv apache-ant-1.8.4 $HOME/opt/apache-ant

### Add Android tools and platform tools to PATH
ENV ANDROID_HOME $HOME/opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV ANT_HOME $HOME/opt/apache-ant
ENV PATH $PATH:$ANT_HOME/bin
ENV JAVA_HOME /usr/lib/jvm/java-6-oracle

### Install latest android (19 / 4.4.2) tools and system image.
RUN echo "y" | android update sdk --no-ui --filter platform-tools,android-19,build-tools-19.1.0,sysimg-19

### Remove compressed files.
RUN rm android-sdk_r22.3-linux.tgz && rm android-ndk-r9c-linux-x86_64.tar.bz2 && rm apache-ant-1.8.4-bin.tar.gz
# }}}

# ---- Setup ssh login ----
#ENTRYPOINT sudo /etc/init.d/ssh start && /bin/bash
ADD startup.sh /tmp/startup.sh
RUN sudo chmod a+x /tmp/startup.sh
ENTRYPOINT ["/tmp/startup.sh"]
CMD []
