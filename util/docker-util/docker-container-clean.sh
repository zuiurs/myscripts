#!/bin/bash

docker rm -f `docker ps -a | tr -s " " | rev | cut -d  " " -f1 | rev | grep -v NAMES | tr "\n" " "`
