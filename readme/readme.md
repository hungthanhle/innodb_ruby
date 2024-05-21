```
docker run --name innodb_ruby -it ubuntu:20.04 bash

apt-get update && apt-get install -y \
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

service mysql start

mysql -v

SELECT VERSION();

apt-get update && \
    apt-get install -y \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    software-properties-common \
    libffi-dev

git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    ~/.rbenv/bin/rbenv init

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

~/.rbenv/bin/rbenv install 3.0.4 && \
    ~/.rbenv/bin/rbenv global 3.0.4

~/.rbenv/versions/3.0.4/bin/ruby -v

~/.rbenv/shims/gem install bundler

~/.rbenv/shims/gem -v

~/.rbenv/shims/gem install innodb_ruby

~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 system-spaces
```
