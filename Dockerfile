FROM wasabeef/android:latest
MAINTAINER Ikuo Matsumura <makiczar@gmail.com>

RUN yum -y install initscripts MAKEDEV
RUN yum check && yum -y update
RUN yum -y install openssh-server
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start
EXPOSE 22

# Install sbt
RUN wget https://dl.bintray.com/sbt/rpm/sbt-0.13.6.rpm
RUN yum install -y java-devel
RUN rpm -i sbt-0.13.6.rpm

# Make user 'centos'
RUN useradd centos -m -g wheel
RUN cd /home/centos

# Startup script
ADD startup.sh /tmp/startup.sh
RUN chown centos /tmp/startup.sh && chmod a+x /tmp/startup.sh

# ---- Run as centos user ----
USER centos
WORKDIR /home/centos
ENV HOME /home/centos
RUN mkdir $HOME/opt/

ENTRYPOINT ["/tmp/startup.sh"]
