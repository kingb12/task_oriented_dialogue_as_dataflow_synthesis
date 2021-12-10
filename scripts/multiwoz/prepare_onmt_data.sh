data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
dataflow_dialogues_dir="${data_root}/output/dataflow_dialogues"
onmt_text_data_dir="${data_root}/output/onmt_text_data"

mkdir -p "${onmt_text_data_dir}"

for subset in "train" "valid" "test"; do
    python -m dataflow.onmt_helpers.create_onmt_text_data \
        --dialogues_jsonl ${dataflow_dialogues_dir}/${subset}.dataflow_dialogues.jsonl \
        --num_context_turns 2 \
        --include_agent_utterance \
        --onmt_text_data_outbase ${onmt_text_data_dir}/${subset}
done