data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
belief_state_tracker_eval_dir="${data_root}/output/belief_state_tracker_eval"
evaluation_outdir="${data_root}/output/evaluation_output"
patched_trade_dialogues_dir="${data_root}/output/patched_trade_dialogues"

mkdir -p "${belief_state_tracker_eval_dir}"

# creates the gold file from TRADE-preprocessed dialogues (after patch)
python -m dataflow.multiwoz.create_belief_state_tracker_data \
    --trade_data_file ${patched_trade_dialogues_dir}/test_dials.json \
    --belief_state_tracker_data_file ${belief_state_tracker_eval_dir}/test.belief_state_tracker_data.jsonl

# creates the hypo file from predicted programs
python -m dataflow.multiwoz.execute_programs \
    --dialogues_file ${evaluation_outdir}/test.dataflow_dialogues.jsonl \
    --cheating_mode never \
    --outbase ${belief_state_tracker_eval_dir}/test.hypo

python -m dataflow.multiwoz.create_belief_state_prediction_report \
    --input_data_file ${belief_state_tracker_eval_dir}/test.hypo.execution_results.jsonl \
    --format dataflow \
    --remove_none \
    --gold_data_file ${belief_state_tracker_eval_dir}/test.belief_state_tracker_data.jsonl \
    --outbase ${belief_state_tracker_eval_dir}/test

# evaluates belief state predictions
python -m dataflow.multiwoz.evaluate_belief_state_predictions \
    --prediction_report_jsonl ${belief_state_tracker_eval_dir}/test.prediction_report.jsonl \
    --outbase ${belief_state_tracker_eval_dir}/test