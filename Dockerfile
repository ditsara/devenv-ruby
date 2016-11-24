FROM debian:jessie
MAINTAINER Dan Itsara <dan@glazziq.com>

RUN apt-get update -qq && \
  apt-get install -y -q \
    build-essential libpq-dev nodejs-legacy git zsh sudo locales \
    curl wget python python-pip vim-nox mosh software-properties-common \
    postgresql postgresql-contrib

# Use latest tmux from jessie-backports
RUN apt-add-repository "deb http://httpredir.debian.org/debian \
      jessie-backports main contrib non-free" && \
  apt-get update -qq && \
  apt-get -t jessie-backports install -y -q tmux

# Set locale to en_US.UTF-8 to satisfy tmux 2+
RUN echo "146\n3\n" | dpkg-reconfigure locales

# PGP key for RVM
RUN gpg --keyserver hkp://pgp.mit.edu \
  --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# Register user/authorize
RUN useradd -d /home/user -G sudo -m -s /bin/zsh user && \
  echo "authorize\nauthorize\n" | passwd user

ADD ./user /home/user
RUN chown -R user /home/user

USER user
WORKDIR /home/user
CMD zsh -l
