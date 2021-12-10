onmt_translate_outdir="output/onmt_translate_output"
onmt_text_data_dir="output/onmt_text_data"
evaluation_outdir="output/evaluation_output"
dataflow_dialogues_dir="output/dataflow_dialogues_v1"
dataflow_dialogues_stats_dir="output/dataflow_dialogues_stats"

mkdir -p "${evaluation_outdir}"
nbest=5

# create the prediction report
python -m dataflow.onmt_helpers.create_onmt_prediction_report \
    --dialogues_jsonl ${dataflow_dialogues_dir}/valid.dataflow_dialogues.jsonl \
    --datum_id_jsonl ${onmt_text_data_dir}/valid.datum_id \
    --src_txt ${onmt_text_data_dir}/valid.src_tok \
    --ref_txt ${onmt_text_data_dir}/valid.tgt \
    --nbest_txt ${onmt_translate_outdir}/valid.nbest \
    --nbest ${nbest} \
    --outbase ${evaluation_outdir}/valid

# evaluate the predictions (all turns)
python -m dataflow.onmt_helpers.evaluate_onmt_predictions \
    --prediction_report_tsv ${evaluation_outdir}/valid.prediction_report.tsv \
    --scores_json ${evaluation_outdir}/valid.all.scores.json

# evaluate the predictions (refer turns)
python -m dataflow.onmt_helpers.evaluate_onmt_predictions \
    --prediction_report_tsv ${evaluation_outdir}/valid.prediction_report.tsv \
    --datum_ids_json ${dataflow_dialogues_stats_dir}/valid.refer_turn_ids.jsonl \
    --scores_json ${evaluation_outdir}/valid.refer_turns.scores.json

# evaluate the predictions (revise turns)
python -m dataflow.onmt_helpers.evaluate_onmt_predictions \
    --prediction_report_tsv ${evaluation_outdir}/valid.prediction_report.tsv \
    --datum_ids_json ${dataflow_dialogues_stats_dir}/valid.revise_turn_ids.jsonl \
    --scores_json ${evaluation_outdir}/valid.revise_turns.scores.json