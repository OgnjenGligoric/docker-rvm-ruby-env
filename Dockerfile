FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt update
RUN apt update && apt install -y gnupg2 curl software-properties-common build-essential libssl-dev zlib1g-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf automake libtool bison libffi-dev
RUN gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io -o rvm.sh
# RUN cat rvm.sh | bash -s stable --rails -- installs ruby with rvm
RUN bash rvm.sh stable
RUN bash -l -c "rvm install 3.0.0"
