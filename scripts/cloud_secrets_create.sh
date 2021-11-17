#!/bin/bash

find scripts \
  -mindepth 1 \
  -type f \
  -name create_secret.sh \
  -exec sh -c {} \;
