# Replicating the original MultiWoZ experiments

This document covers repetition of the original MultiWoZ experiments, which are covered in a 
sequence of bash snippets in the original repository README. For my replication, I needed to make minor tweaks
to the scripting and the repository itself.

## Setup and Changes Made

### Environment
- see setup in [`./replicating_sm_calflow_experiments.md`](./replicating_sm_calflow_experiments.md)

### Changes to Code
- see setup in [`./replicating_sm_calflow_experiments.md`](./replicating_sm_calflow_experiments.md)


### Changes to scripting

I compiled each step in the README into its own bash script under `scripts/multiwoz`. Again, changes reflect the 
`citrisdance` execution environment and would only work in an environment setup like mine (as described above, 
with hopefully few or no missing steps). Scripts must also be run in a precise order:

### How to execute:

Install according to README with updates according to environment description above, then run the bash 
scripts in the following order:

- `bash scripts/multiwoz/download_multiwoz_and_build_dataflow_programs.sh`
- `bash scripts/multiwoz/prepare_onmt_data.sh`
- `bash scripts/multiwoz/compute_onmt_data_statistics.sh`
- `bash scripts/multiwoz/train_onmt_models.sh`


This outputs a number of things over each script (models, processed data, predictions, evaluation metrics, etc.). Follow
the analogous steps in the README for a better understanding (scripts are just modifications so that each step can be 
run like above.)

## Results

The top-level metrics from evaluation are in `TODO`, and roughly match the 
accuracies reported in [Table 3](https://arxiv.org/abs/2009.11423). 

```json
{
  "TODO": "results"
}
```