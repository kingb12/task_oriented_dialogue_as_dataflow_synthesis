dataflow_dialogues_dir="output/dataflow_dialogues_v2"
onmt_text_data_dir="output/onmt_text_data_v2"
mkdir -p "${onmt_text_data_dir}"
for subset in "train" "valid"; do
    python -m dataflow.onmt_helpers.create_onmt_text_data \
        --dialogues_jsonl ${dataflow_dialogues_dir}/${subset}.dataflow_dialogues.jsonl \
        --num_context_turns 2 \
        --include_program \
        --include_described_entities \
        --onmt_text_data_outbase ${onmt_text_data_dir}/${subset}
done