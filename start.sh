#!/bin/bash

service haproxy start
(cd /plantuml-server; mvn jetty:run &)
(cd /gollum; gollum --css --port 4568 --config /config.rb)
