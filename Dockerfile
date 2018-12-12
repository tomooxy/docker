FROM centos:latest

ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY

# jdkインストール
RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
# OpenSSH サーバをインストールする
RUN yum -y install openssh-server

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64
ENV PATH $PATH:$JAVA_HOME/bin
ENV CLASSPATH .:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar 

# wgetインストール
RUN yum -y install wget
#RUN wget http://wing-repo.net/wing/6/EL6.wing.repo -P /etc/yum.repos.d/
#RUN cd /etc/yum.repos.d/
#RUN wget http://wing-repo.net/wing/6/EL6.wing.repo
# git をインストールする
RUN yum -y install git

# nc nmap をインストールする
RUN yum -y install nc nmap

# mvn インストール
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y apache-maven

# root でログインできるようにする
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# root のパスワードを 設定
RUN echo 'root:password' | chpasswd

# 使わないにしてもここに公開鍵を登録しておかないとログインできない
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key

# sshd の使うポートを公開する
EXPOSE 22

# sshd を起動する
CMD ["/usr/sbin/sshd", "-D"]