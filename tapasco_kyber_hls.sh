#!/bin/bash
#SBATCH -J tapasco_kyber_hls

#SBATCH -D /net/cirithungol/rs/thesis/kyber/kyber
#SBATCH -e /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.err
#SBATCH -o /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.out

#SBATCH --partition=Epyc

#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=4096
#SBATCH -t 72:00:00

echo "Slurm Job ID: $SLURM_JOB_ID"

# $HOME needs to be set to a writable directory or Vivado will fail
# silently without throwing an error.
mkdir -p /net/cirithungol/rs
export HOME=/net/cirithungol/rs

# Using Vitis 2020.2:
source /opt/cad/xilinx/vitis/Vivado/2020.2/settings64.sh
source ./tapasco-setup.sh

# Perform HLS but skip evaluation because I don't want to do design space
# exploration (yet) and it takes ages to route this with 1 GHz..
#
# Comment the Keypair Generation because it doesn't make any sense without a
# good source of randomness:
#tapasco hls kyber2_gen --skipEvaluation -p vc709

tapasco hls kyber2_enc --skipEvaluation -p vc709,AU280
tapasco hls kyber2_dec --skipEvaluation -p vc709,AU280

tapasco hls kyber3_enc --skipEvaluation -p vc709,AU280
tapasco hls kyber3_dec --skipEvaluation -p vc709,AU280

tapasco hls kyber4_enc --skipEvaluation -p vc709,AU280
tapasco hls kyber4_dec --skipEvaluation -p vc709,AU280

# Encryption and Decryption for each security level in one design
#tapasco compose [ kyber2_enc x 1, kyber2_dec x 1 ] @ 100 MHz -p vc709,AU280
#tapasco compose [ kyber3_enc x 1, kyber3_dec x 1 ] @ 100 MHz -p vc709,AU280
#tapasco compose [ kyber4_enc x 1, kyber4_dec x 1 ] @ 100 MHz -p vc709,AU280

# All security levels in one design
tapasco compose [ kyber2_enc x 1, kyber3_enc x 1, kyber4_enc x 1, kyber2_dec x 1, kyber3_dec x 1, kyber4_dec x 1 ] @ 50 MHz -p vc709,AU280
