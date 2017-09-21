#!/bin/bash

set -x

echo "Hello! starting $(date)"

sudo rm -rf taxoner.img
singularity create -s 1500 taxoner.img
sudo singularity bootstrap taxoner.img ubuntu.sh

echo "Goodbye! ending $(date)"
