#!/usr/bin/env bash
mkdir -p v1/gen v2/gen
for version in 1.* 2.0.0
do
  thrift --out $version/gen --gen rb $version/accounts.thrift 
done