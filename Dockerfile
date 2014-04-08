FROM centos

# telnet is required by some fabric command. without it you have silent failures
RUN yum install -y java-1.7.0-openjdk which telnet unzip openssh-server sudo openssh-clients
# enable no pass and speed up authentication
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/;s/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

# enabling sudo group
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
# enabling sudo over ssh
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

ENV JAVA_HOME /usr/lib/jvm/jre

# add a user for the application, with sudo permissions
RUN useradd -m fabric8 ; echo fabric8: | chpasswd ; usermod -a -G wheel fabric8

# assigning higher default ulimits
# unluckily this is not very portable. these values work only if the user running docker daemon on the host has his own limits >= than values set here
# if they are not, the risk is that the "su fuse" operation will fail
RUN echo "fabric8                -       nproc           4096" >> /etc/security/limits.conf
RUN echo "fabric8                -       nofile           4096" >> /etc/security/limits.conf

# command line goodies
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre" >> /etc/profile
RUN echo "alias ll='ls -l --color=auto'" >> /etc/profile
RUN echo "alias grep='grep --color=auto'" >> /etc/profile


WORKDIR /home/fabric8

RUN mkdir lib
RUN chown -R fabric8:fabric8 lib

USER fabric8

RUN curl --silent --output startup.sh https://raw.githubusercontent.com/fabric8io/fabric8-tomcat-docker/f20fcfe81f59e53128013c9ddd14e90a15853f7f/startup.sh
RUN chmod +x startup.sh

EXPOSE 22 8080

USER root

CMD /home/fabric8/startup.sh
