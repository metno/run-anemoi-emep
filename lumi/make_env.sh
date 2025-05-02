#!/bin/bash

cd $(pwd -P)

# Make files executable in the container (might not be needed)
chmod 770 env_setup.sh

PROJECT_DIR=/pfs/lustrep2/scratch/project_465001905
CONTAINER=$PROJECT_DIR/container/lumi-rocm-6.2.2-python-3.12-pytorch-2.5.1-kl-aq-anemoi.sif

# Clone and pip install anemoi repos from the container
singularity exec -B /pfs:/pfs $CONTAINER $(pwd -P)/env_setup.sh
