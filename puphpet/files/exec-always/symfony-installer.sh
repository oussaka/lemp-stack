#!/usr/bin/env bash

mkdir -p /usr/local/bin
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony