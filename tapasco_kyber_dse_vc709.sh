#!/bin/bash
#SBATCH -J tapasco_kyber_dse

#SBATCH -D /net/cirithungol/rs/thesis/kyber/kyber
#SBATCH -e /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.err
#SBATCH -o /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.out

#SBATCH --partition=Epyc

#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=4096
#SBATCH -t 168:00:00

echo "Slurm Job ID: $SLURM_JOB_ID"

# $HOME needs to be set to a writable directory or Vivado will fail
# silently without throwing an error.
mkdir -p /net/cirithungol/rs
export HOME=/net/cirithungol/rs

# Using Vitis 2020.2:
source /opt/cad/xilinx/vitis/Vivado/2020.2/settings64.sh
source ./tapasco-setup.sh

# Perform HLS
tapasco hls kyber2_enc --skipEvaluation -p vc709
tapasco hls kyber2_dec --skipEvaluation -p vc709

tapasco hls kyber3_enc --skipEvaluation -p vc709
tapasco hls kyber3_dec --skipEvaluation -p vc709

tapasco hls kyber4_enc --skipEvaluation -p vc709
tapasco hls kyber4_dec --skipEvaluation -p vc709


# Design Space Exploration for Max Frequency on VC709 and vc709
tapasco explore [ kyber2_enc x 1 ] @ 600 MHz in frequency -p vc709
tapasco explore [ kyber3_enc x 1 ] @ 600 MHz in frequency -p vc709
tapasco explore [ kyber4_enc x 1 ] @ 600 MHz in frequency -p vc709

tapasco explore [ kyber2_dec x 1 ] @ 600 MHz in frequency -p vc709
tapasco explore [ kyber3_dec x 1 ] @ 600 MHz in frequency -p vc709
tapasco explore [ kyber4_dec x 1 ] @ 600 MHz in frequency -p vc709
