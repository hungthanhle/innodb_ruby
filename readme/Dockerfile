# Base image
FROM ubuntu:20.04

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# Update package lists
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server-10.3 \
    build-essential \
    libssl-dev \
    libreadline-dev \
    curl \
    git \
    zlib1g-dev \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Start MySQL service
RUN service mysql start

# Install Ruby development dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libffi-dev

# Install rbenv and ruby-build
RUN apt-get update && apt-get install -y ca-certificates && \
    update-ca-certificates
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# Install Ruby version 3.0.4
RUN ~/.rbenv/bin/rbenv install 3.0.4 && \
    ~/.rbenv/bin/rbenv global 3.0.4

# Verify Ruby installation
RUN ~/.rbenv/versions/3.0.4/bin/ruby -v

# Install Bundler
RUN ~/.rbenv/shims/gem install bundler

# Check Gem version
RUN ~/.rbenv/shims/gem -v

# Install innodb_ruby gem
RUN ~/.rbenv/shims/gem install innodb_ruby

# System space configuration (assuming for MySQL)
RUN ~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 system-spaces

# Expose port (optional)
# EXPOSE 3306  # Exposes the default MySQL port
