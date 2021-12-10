onmt_text_data_dir="output/onmt_text_data_v2"
onmt_data_stats_dir="output/onmt_data_stats_v2"
mkdir -p "${onmt_data_stats_dir}"
python -m dataflow.onmt_helpers.compute_onmt_data_stats \
    --text_data_dir ${onmt_text_data_dir} \
    --suffix src src_tok tgt \
    --subset train valid \
    --outdir ${onmt_data_stats_dir}