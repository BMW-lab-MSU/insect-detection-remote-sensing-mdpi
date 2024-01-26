# Slurm scripts
This directory contains all the slurm scripts used to run the code on a slurm cluster.

## Launching the jobs
The easiest way to run the code is to launch the follow shell scripts, which queue the jobs and handle dependencies:

- `prepare-data.sh`: Prepares the data (preprocessing, train/validation/test split, etc.)
- `precompute-features.sh`: Precomputes the feature extraction on each of the datasets. This is only needed for the feature-based row methods.
- `run-row-methods.sh`: Runs all the row-based methods. `prepare-data.sh` and `precompute-features.sh` must be run before this.
- `run-image-methods.sh`: Runs all the image-based methods.
- `run-changepoint-methods.sh`: Runs the changepoint detection methods.

Each script handles dependencies within itself, but dependencies between scripts are not handled. Thus you must run `prepare-data.sh` and wait for all jobs to be done before running any of the other scripts. Similarly, all jobs launched by `precompute-features.sh` must be done before running `run-row-methods.sh`.

## Configuring for your cluster
The `account` and `partition` parameters are left blank in all the slurm files. Thus you must update those for your cluster. If you can run all the code with your default account and partition, then you can delete all the `account` and `partition` lines. This is fastest to do with `sed`:
```bash
sed -i '/account/d' *.slurm
sed -i '/partition/d' *.slurm
```

You can also use `sed` to batch update the `account` and `partition` parameters for files.

Be aware that many of the GPU-capable algorithms are set to use GPUs. These settings will almost certainly need to be updated for your cluster.