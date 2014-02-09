#!/usr/bin/env bash
mkdir -p v1/gen v2/gen
for version in v1 v2 v3
do
  thrift --out $version/gen --gen rb $version/ais.thrift 
done