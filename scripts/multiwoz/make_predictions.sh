data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
onmt_text_data_dir="${data_root}/output/onmt_text_data"
onmt_data_stats_dir="${data_root}/output/onmt_data_stats"
onmt_models_dir="${data_root}/output/onmt_models_multiwoz"

onmt_translate_outdir="${data_root}output/onmt_translate_output"
mkdir -p "${onmt_translate_outdir}"

# for this to work, I opted to look at the training output and copy the model that has the best validation
# loss to the below location (rather than adjust the script). A better approach probabily uses a variable.
onmt_model_pt="${onmt_models_dir}/checkpoint_last.pt"
nbest=5
tgt_max_ntokens=$(jq '."100"' ${onmt_data_stats_dir}/train.tgt.ntokens_stats.json)

# predict programs on the test set using a trained OpenNMT model
onmt_translate \
    --model ${onmt_model_pt} \
    --max_length ${tgt_max_ntokens} \
    --src ${onmt_text_data_dir}/test.src_tok \
    --replace_unk \
    --n_best ${nbest} \
    --batch_size 8 \
    --beam_size 10 \
    --gpu 0 \
    --report_time \
    --output ${onmt_translate_outdir}/test.nbest