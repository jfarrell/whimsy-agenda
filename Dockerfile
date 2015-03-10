# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:trusty
MAINTAINER Apache Infrastructure <infrastructure@apache.org>

ENV IOJS_VERSION 1.5.1
ENV PHANTOMJS_VERSION 1.9.8

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install build-essential \
    git subversion mercurial curl lsof \
    libfreetype6 libfontconfig1 zlib1g-dev libssl-dev libldap2-dev libsasl2-dev

RUN mkdir -p /usr/local/iojs && \
    curl -sSL https://iojs.org/dist/v${IOJS_VERSION}/iojs-v${IOJS_VERSION}-linux-x64.tar.gz | tar -C /usr/local/iojs -xz --strip-components=1 && \
    ln -s /usr/local/iojs/bin/iojs /usr/bin/iojs && \
    ln -s /usr/local/iojs/bin/node /usr/bin/node && \
    ln -s /usr/local/iojs/bin/npm /usr/bin/npm

RUN mkdir -p /usr/local/phantomjs && \
    curl -sSL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar -C /usr/local/phantomjs -xj --strip-components=1 && \
    ln -s /usr/local/phantomjs/bin/phantomjs /usr/bin/phantomjs

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable --ruby && \
    echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc && \
    /usr/local/rvm/bin/rvm-shell -c "gem install bundler pry"

# Clean up
RUN apt-get clean && \
      rm -rf /var/cache/apt/* && \
      rm -rf /var/lib/apt/lists/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

WORKDIR $HOME
ENTRYPOINT ["/usr/local/rvm/bin/rvm-shell"]
