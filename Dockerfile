FROM ubuntu:24.04


RUN apt-get update && \
    apt-get install -y build-essential libpq-dev nodejs curl gpg && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-lc"]
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys \
        409B6B1796C275462A1703113804BB82D39DC0E3 \
        7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable && \
    echo "source /etc/profile.d/rvm.sh" >> /etc/bash.bashrc
RUN rvm get head
RUN rvm requirements && \
    rvm pkg install openssl && \
    rvm install ruby-2.7.5 --with-openssl-dir=/usr/local/rvm/usr