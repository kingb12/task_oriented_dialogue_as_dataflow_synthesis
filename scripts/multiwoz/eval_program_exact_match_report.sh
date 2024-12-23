data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
onmt_text_data_dir="${data_root}/output/onmt_text_data"
onmt_translate_outdir="${data_root}output/onmt_translate_output"
dataflow_dialogues_dir="${data_root}/output/dataflow_dialogues"

evaluation_outdir="${data_root}/output/evaluation_output"
mkdir -p "${evaluation_outdir}"

# create the prediction report
python -m dataflow.onmt_helpers.create_onmt_prediction_report \
    --dialogues_jsonl ${dataflow_dialogues_dir}/test.dataflow_dialogues.jsonl \
    --datum_id_jsonl ${onmt_text_data_dir}/test.datum_id \
    --src_txt ${onmt_text_data_dir}/test.src_tok \
    --ref_txt ${onmt_text_data_dir}/test.tgt \
    --nbest_txt ${onmt_translate_outdir}/test.nbest \
    --nbest 5 \
    --outbase ${evaluation_outdir}/test

# evaluate the predictions
python -m dataflow.onmt_helpers.evaluate_onmt_predictions \
    --prediction_report_tsv ${evaluation_outdir}/test.prediction_report.tsv \
    --scores_json ${evaluation_outdir}/test.scores.json