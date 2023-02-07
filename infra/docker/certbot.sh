#!/bin/bash
source ../.secret
docker run --rm -it -v /etc/letsencrypt:/etc/letsencrypt -v $(pwd):/tmp certbot/dns-ovh:v2.2.0 certonly --dns-ovh --dns-ovh-credentials /tmp/.ovhapi --non-interactive --agree-tos --email thomaspelletier44@gmail.com -d *.adminadmin.fr
docker exec nginx nginx -s reload