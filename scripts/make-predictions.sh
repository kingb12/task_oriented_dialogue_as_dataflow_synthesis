onmt_translate_outdir="output/onmt_translate_output"
onmt_text_data_dir="output/onmt_text_data"
onmt_data_stats_dir="output/onmt_data_stats"
onmt_models_dir="output/models"
mkdir -p "${onmt_translate_outdir}"

onmt_model_pt="${onmt_models_dir}/smcalflow.full.checkpoint_last.pt"
nbest=5
tgt_max_ntokens=$(jq '."100"' ${onmt_data_stats_dir}/train.tgt.ntokens_stats.json)

# predict programs using a trained OpenNMT model
onmt_translate \
    --model ${onmt_model_pt} \
    --max_length ${tgt_max_ntokens} \
    --src ${onmt_text_data_dir}/valid.src_tok \
    --replace_unk \
    --n_best ${nbest} \
    --batch_size 8 \
    --beam_size 10 \
    --gpu 1 \
    --report_time \
    --output ${onmt_translate_outdir}/valid.nbest