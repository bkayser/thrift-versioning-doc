#!/usr/bin/env bash
mkdir -p v1/gen v2/gen
for version in 1.*
do
  thrift --out $version/gen --gen rb $version/ais.thrift 
done