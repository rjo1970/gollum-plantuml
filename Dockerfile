FROM ruby:latest

ENV RACK_ENV production

RUN apt-get update && apt-get upgrade -y

RUN apt-get remove bzr mercurial libmysqlclient-dev subversion \
                   libmysqlclient-dev libsqlite3-dev -y

RUN apt-get install openjdk-7-jdk maven graphviz libicu-dev -y

RUN apt-get install haproxy -y

RUN git clone https://github.com/plantuml/plantuml-server.git
RUN cd plantuml-server && git checkout v2017.11
RUN cd plantuml-server && mvn package && mvn jetty:help

RUN git init gollum
WORKDIR /gollum
COPY Home.md /gollum/Home.md
RUN git add Home.md && git -c user.email="anonymous@email.com" \
    -c user.name="Anonymous" commit -am "Created Home (markdown)"

RUN gem install puma gollum
COPY config.rb /config.rb

COPY haproxy.cfg /etc/haproxy/haproxy.cfg
RUN echo "ENABLED=1" >> /etc/default/haproxy

COPY start.sh /start.sh

CMD "bash" "/start.sh"

EXPOSE 4567
