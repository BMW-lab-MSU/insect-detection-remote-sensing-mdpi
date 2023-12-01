#!/bin/bash

sbatch precomputeTrainingFeatures.slurm
sbatch precomputeValidationFeatures.slurm
sbatch precomputeTestingFeatures.slurm

