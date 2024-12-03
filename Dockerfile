FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://get.rvm.io | bash -s stable

SHELL ["/bin/bash", "-l", "-c"]

RUN rvm install 2.3 --latest && \
    rvm install 2.4 --latest && \
    rvm install 2.5 --latest && \
    rvm install 2.6 --latest && \
    rvm install 2.7 --latest && \
    rvm install 3.0 --latest && \
    rvm install 3.1 --latest && \
    rvm install 3.2 --latest && \
    rvm install 3.3 --latest && \
    rvm cleanup

RUN rvm use 3.3 --default

RUN ruby -v && gem -v && rvm list

WORKDIR /app

COPY verify_app.sh /usr/local/bin/verify_app.sh

RUN chmod +x /usr/local/bin/verify_app.sh

CMD ["/usr/local/bin/verify_app.sh"]
