dataflow_dialogues_dir="output/dataflow_dialogues_v2"
dataflow_dialogues_stats_dir="output/dataflow_dialogues_stats_v2"
mkdir -p "${dataflow_dialogues_stats_dir}"
python -m dataflow.analysis.compute_data_statistics \
    --dataflow_dialogues_dir ${dataflow_dialogues_dir} \
    --subset train valid \
    --outdir ${dataflow_dialogues_stats_dir}