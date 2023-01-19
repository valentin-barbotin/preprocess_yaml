#!/usr/bin/env bash

INPUT=$1
OUTPUT=$2

if [ -z "$INPUT" ]; then
    echo "Input file is required"
    exit 1
fi

if [ -z "$OUTPUT" ]; then
    echo "Output file is required"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Input file does not exist"
    exit 1
fi

echo "Processing $INPUT"

declare -A tokens

while read line; do
    # if [[ $line =~ (.+: *&\w+(\w|\d)* "\w+(\w|\d)*") ]]; then
    if [[ $line =~ (: &[[:alnum:]]+ \"[[:alnum:]]*\") ]]; then
        key=$(echo $line | cut -d'&' -f2 | cut -d' ' -f1)
        value=$(echo $line | cut -d'"' -f2)
        tokens[$key]=$value
    fi
done < $INPUT

LENGTH=${#tokens[@]}

if [ $LENGTH -eq 0 ]; then
    echo "No tokens found"
    exit 0
fi

for key in ${!tokens[@]}; do
    echo "Replacing $key with ${tokens[$key]}"

    if [ "$INPUT" = "$OUTPUT" ]; then
        sed -i "s/*$key/${tokens[$key]}/g" $INPUT
    else
        sed "s/*$key/${tokens[$key]}/g" $INPUT
    fi
done
