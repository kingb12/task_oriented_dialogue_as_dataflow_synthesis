data_root="/scratchdata/bking2/tod_as_df_synthesis/multiwoz"
raw_trade_dialogues_dir="${data_root}/output/trade_dialogues"
patched_trade_dialogues_dir="${data_root}/output/patched_trade_dialogues"
dataflow_dialogues_dir="${data_root}/output/dataflow_dialogues"

# creates TRADE-processed dialogues
mkdir -p "${raw_trade_dialogues_dir}"
python -m dataflow.multiwoz.trade_dst.create_data \
    --use_multiwoz_2_1 \
    --output_dir ${raw_trade_dialogues_dir}

# patch TRADE dialogues
mkdir -p "${patched_trade_dialogues_dir}"
for subset in "train" "dev" "test"; do
    python -m dataflow.multiwoz.patch_trade_dialogues \
        --trade_data_file ${raw_trade_dialogues_dir}/${subset}_dials.json \
        --outbase ${patched_trade_dialogues_dir}/${subset}
done
ln -sr ${patched_trade_dialogues_dir}/dev_dials.json ${patched_trade_dialogues_dir}/valid_dials.json

# create dataflow programs
mkdir -p "${dataflow_dialogues_dir}"
for subset in "train" "valid" "test"; do
    python -m dataflow.multiwoz.create_programs \
        --trade_data_file ${patched_trade_dialogues_dir}/${subset}_dials.json \
        --outbase ${dataflow_dialogues_dir}/${subset}
done