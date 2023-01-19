#!/usr/bin/env bash

declare -A tokens

while read line; do
    # if [[ $line =~ (.+: *&\w+(\w|\d)* "\w+(\w|\d)*") ]]; then
    if [[ $line =~ (: &[[:alnum:]]+ \"[[:alnum:]]*\") ]]; then
        key=$(echo $line | cut -d'&' -f2 | cut -d' ' -f1)
        value=$(echo $line | cut -d'"' -f2)
        tokens[$key]=$value
    fi
done < values.yaml

for key in ${!tokens[@]}; do
    sed "s/*$key/${tokens[$key]}/g" values.yaml
done
