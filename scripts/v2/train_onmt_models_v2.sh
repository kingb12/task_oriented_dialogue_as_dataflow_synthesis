# pre-requisite directories
onmt_data_stats_dir="output/onmt_data_stats_v2"
onmt_text_data_dir="output/onmt_text_data_v2"

# output directories
onmt_binarized_data_dir="output/onmt_binarized_data_v2"
glove_840b_dir="/tmp/glove_840b"
onmt_embeddings_dir="output/onmt_embeddings_v2"
onmt_models_dir="/scratchdata/bking2/tod_as_df_synthesis/output/onmt_models_v2"

mkdir -p "${onmt_binarized_data_dir}"

src_tok_max_ntokens=$(jq '."100"' ${onmt_data_stats_dir}/train.src_tok.ntokens_stats.json)
tgt_max_ntokens=$(jq '."100"' ${onmt_data_stats_dir}/train.tgt.ntokens_stats.json)

# create OpenNMT binarized data
onmt_preprocess \
    --dynamic_dict \
    --train_src ${onmt_text_data_dir}/train.src_tok \
    --train_tgt ${onmt_text_data_dir}/train.tgt \
    --valid_src ${onmt_text_data_dir}/valid.src_tok \
    --valid_tgt ${onmt_text_data_dir}/valid.tgt \
    --src_seq_length ${src_tok_max_ntokens} \
    --tgt_seq_length ${tgt_max_ntokens} \
    --src_words_min_frequency 0 \
    --tgt_words_min_frequency 0 \
    --save_data ${onmt_binarized_data_dir}/data

# extract pretrained Glove 840B embeddings (https://nlp.stanford.edu/projects/glove/)
mkdir -p "${glove_840b_dir}"
glove_zip_file=${glove_840b_dir}/glove.840B.300d.zip
if [ -f "${glove_zip_file}" ]; then
    echo "${glove_zip_file} exists."
else
  wget -O ${glove_840b_dir}/glove.840B.300d.zip http://nlp.stanford.edu/data/glove.840B.300d.zip
  unzip ${glove_840b_dir}/glove.840B.300d.zip -d ${glove_840b_dir}
fi

embeddings_file=${onmt_embeddings_dir}/embeddings.enc.pt


if [ -f "${embeddings_file}" ]; then
    echo "${embeddings_file} exists."
else
  mkdir -p "${onmt_embeddings_dir}"
  python -m dataflow.onmt_helpers.embeddings_to_torch \
    -emb_file_both ${glove_840b_dir}/glove.840B.300d.txt \
    -dict_file ${onmt_binarized_data_dir}/data.vocab.pt \
    -output_file ${embeddings_file}
fi

# train OpenNMT models
mkdir -p "${onmt_models_dir}"

batch_size=64
train_num_datapoints=$(jq '.train' ${onmt_data_stats_dir}/nexamples.json)
# validate approximately at each epoch
valid_steps=$(python3 -c "from math import ceil; print(ceil(${train_num_datapoints}/${batch_size}))")

# note layers and rnn_size are hyperparameters
onmt_train \
    --encoder_type brnn \
    --decoder_type rnn \
    --rnn_type LSTM \
    --global_attention general \
    --global_attention_function softmax \
    --generator_function softmax \
    --copy_attn_type general \
    --copy_attn \
    --seed 1 \
    --optim adam \
    --learning_rate 0.001 \
    --early_stopping 2 \
    --batch_size ${batch_size} \
    --valid_batch_size 8 \
    --valid_steps ${valid_steps} \
    --save_checkpoint_steps ${valid_steps} \
    --data ${onmt_binarized_data_dir}/data \
    --pre_word_vecs_enc ${onmt_embeddings_dir}/embeddings.enc.pt \
    --pre_word_vecs_dec ${onmt_embeddings_dir}/embeddings.dec.pt \
    --word_vec_size 300 \
    --attention_dropout 0 \
    --dropout 0.5 \
    --layers 2 \
    --rnn_size 384 \
    --gpu_ranks 0 \
    --world_size 1 \
    --save_model ${onmt_models_dir}/checkpoint