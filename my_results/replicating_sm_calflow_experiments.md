# Replicating the original SMCalFlow experiments

This document covers repetition of the original SMCalFlow experiments, which are covered in a 
sequence of bash snippets in the original repository README. For my replication, I needed to make minor tweaks
to the scripting and the repository itself.

## Setup and Changes Made

### Environment
- These experiments are replicated on `citrisdance`, with a python virtual environment for `3.7.11`
- An important note: in order to successfully use the GPU(s) on `citrisdance` it was required to use
`torch==1.4.0+cu101` from the binaries managed by Nelson Liu: 
`pip install torch==1.4.0+cu101 -f https://nelsonliu.me/files/pytorch/whl/torch_stable.html`. 
This is because of the underlying drivers for older GPUs no longer being supported by torch out of the box. 
See the [Github Repo](https://github.com/nelson-liu/pytorch-manylinux-binaries) for details.

### Changes to Code

Changes to the code centered around dealing with broken dataset examples. In the example processing in 
`create_onmt_text_data.py`, assertions are used to validate dialogues. In both the v1 and v2 dataset, there was at least
broken dialogue (less than 5 in both cases). I modified the processing to print a warning and throw out the dialogue 
instead of crashing. **NOTE: this may cause a mismatch between the computed dataset statistics and the actual number of 
dialogues.** Anecdotally the impact of this wasn't significant enough to cause validation or training issues but it 
would be worth investigating if we later need to be more precise.

### Changes to scripting

I compiled each step in the README into its own bash script, more carefully for the v2 dataset than the v1 dataset under
`scripts/v2` (`v1` is in the outer folder and might reflect early changes for v2, I wasn't careful about this to start).
These are mostly around dealing with disk locations on `citrisdance` given the project lives in a home directory but needs
to write more space than this permits. 

### How to execute:

For `v2`, install according to README with updates according to environment description above, then run the bash 
scripts in the following order:

- `bash scripts/v2/unpack_dialogues_v2.sh`
- `bash scripts/v2/compute_data_statistics_v2.sh`
- `bash scripts/v2/prepare_onmt_data_v2.sh`
- `bash scripts/v2/compute_onmt_data_statistics_v2.sh`
- `bash scripts/v2/train_onmt_models_v2.sh`
- `bash scripts/v2/make_predictions_v2.sh`
- `bash scripts/v2/example_evaluation_v2.sh`

This outputs a number of things over each script (models, processed data, predictions, evaluation metrics, etc.). Follow
the analogous steps in the README for a better understanding (scripts are just modifications so that each step can be 
run like above.)

## Results

The top-level metrics from evaluation are in `output/evaluation_output_v2/valid.all.scores.json`, and roughly match the 
accuracies reported in [Table 2](https://arxiv.org/abs/2009.11423). Note: paper is reporting on v1 of the dataset which 
is annotated differently, hence the significant discrepancy. The v1 replication I did (not discussed here but 
essentially follows a similar path) was more in line with their results:

```json
{
  "notIgnoringRefer": {
    "accuracy": 0.7058387670420866,
    "ave_num_turns_before_first_error": 1.68398392652124,
    "num_correct_dialogues": 1183,
    "num_correct_turns": 9526,
    "num_total_dialogues": 3484,
    "num_total_turns": 13496,
    "num_turns_before_first_error": 5867,
    "pct_correct_dialogues": 0.33955223880597013
  },
  "ignoringRefer": {
    "accuracy": 0.7276229994072317,
    "ave_num_turns_before_first_error": 1.757462686567164,
    "num_correct_dialogues": 1262,
    "num_correct_turns": 9820,
    "num_total_dialogues": 3484,
    "num_total_turns": 13496,
    "num_turns_before_first_error": 6123,
    "pct_correct_dialogues": 0.3622273249138921
  }
}
```