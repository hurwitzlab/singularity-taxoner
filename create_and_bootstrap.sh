#!/bin/bash

set -x

echo "Hello! starting $(date)"

sudo rm -rf taxoner.img
singularity create -s 4096 taxoner.img
sudo singularity bootstrap taxoner.img ubuntu.def

echo "Goodbye! ending $(date)"
