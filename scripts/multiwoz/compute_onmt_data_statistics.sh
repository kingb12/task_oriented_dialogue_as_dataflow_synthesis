data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
onmt_text_data_dir="${data_root}/output/onmt_text_data"
onmt_data_stats_dir="${data_root}/output/onmt_data_stats"

mkdir -p "${onmt_data_stats_dir}"

python -m dataflow.onmt_helpers.compute_onmt_data_stats \
    --text_data_dir ${onmt_text_data_dir} \
    --suffix src src_tok tgt \
    --subset train valid test \
    --outdir ${onmt_data_stats_dir}