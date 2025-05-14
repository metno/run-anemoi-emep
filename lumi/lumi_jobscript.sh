#!/bin/bash
#SBATCH --output=/users/%u/%x_%j.out
#SBATCH --error=/users/%u/%x_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=project_465001905
#SBATCH --partition=standard-g
#SBATCH --gpus-per-node=1
#SBATCH --time=24:00:00
#SBATCH --job-name=kl-aq-anemoi
#SBATCH --exclusive


#Change this
CONFIG_NAME=config_v4_lumi.yaml
CONFIG_DIR=/users/ulimoenm/emep-anemoi/training/config4

# There is a bug in anemoi-core/training https://github.com/ecmwf/anemoi-core/issues/320
# which will need to be fixed at some point. Meanwhile use the below container, but run
# first singularity shell $CONTAINER, then pip install -e ~/anemoi-core/training to install
# the package to a location where the container python knows to look, also when the container
# is restarted. The temporary fix is to remove the problematic line.
CONTAINER=/project/project_465001905/container/pytorch-rocm-6.2.4-python-3.12-pytorch-v2.6.0-kl-aq-anemoi.sif

#Should not have to change these
PROJECT_DIR=/scratch/$SLURM_JOB_ACCOUNT
CONTAINER_SCRIPT=$(pwd -P)/run_pytorch.sh
chmod 770 ${CONTAINER_SCRIPT}

module load LUMI partition/G

# MPI + OpenMP bindings: https://docs.lumi-supercomputer.eu/runjobs/scheduled-jobs/distribution-binding
CPU_BIND="mask_cpu:fe000000000000,fe00000000000000,fe0000,fe000000,fe,fe00,fe00000000,fe0000000000"

srun --cpu-bind=$CPU_BIND \
    singularity exec -B /pfs:/pfs \
                     -B /var/spool/slurmd \
                     -B /opt/cray \
		     -B /scratch \
        $CONTAINER $CONTAINER_SCRIPT $CONFIG_DIR $CONFIG_NAME
