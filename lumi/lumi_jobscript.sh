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
# /users/mousinge/Repos/emep-anemoi/training/config3/config.yaml #This file should be located in run-anemoi/lumi

#Should not have to change these
PROJECT_DIR=/scratch/$SLURM_JOB_ACCOUNT
CONTAINER_SCRIPT=$(pwd -P)/run_pytorch.sh
chmod 770 ${CONTAINER_SCRIPT}
CONTAINER=/project/project_465001905/container/pytorch-rocm-6.2.4-python-3.12-pytorch-v2.6.0-kl-aq-anemoi.sif
# VENV=$(pwd -P)/.venv
# export VIRTUAL_ENV=$VENV

module load LUMI partition/G
# export SINGULARITYENV_LD_LIBRARY_PATH=/opt/miniconda3/envs/pytorch/lib/:/opt/ompi/lib:${EBROOTAWSMINOFIMINRCCL}/lib:/opt/cray/xpmem/2.4.4-2.3_9.1__gff0e1d9.shasta/lib64:${SINGULARITYENV_LD_LIBRARY_PATH}

# MPI + OpenMP bindings: https://docs.lumi-supercomputer.eu/runjobs/scheduled-jobs/distribution-binding
CPU_BIND="mask_cpu:fe000000000000,fe00000000000000,fe0000,fe000000,fe,fe00,fe00000000,fe0000000000"

# run run-pytorch.sh in singularity container like recommended
# in LUMI doc: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/p/PyTorch
#srun --cpu-bind=$CPU_BIND \
#    singularity exec -B /pfs:/pfs \
#                     -B /var/spool/slurmd \
#                     -B /opt/cray \
#                     -B /usr/lib64 \
#        $CONTAINER $CONTAINER_SCRIPT $CONFIG_DIR $CONFIG_NAME

srun --cpu-bind=$CPU_BIND \
    singularity exec -B /pfs:/pfs \
                     -B /var/spool/slurmd \
                     -B /opt/cray \
		     -B /scratch \
        $CONTAINER $CONTAINER_SCRIPT $CONFIG_DIR $CONFIG_NAME
