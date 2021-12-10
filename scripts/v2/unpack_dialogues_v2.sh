dataflow_dialogues_dir="output/dataflow_dialogues_v2"
mkdir -p "${dataflow_dialogues_dir}"

cd "${dataflow_dialogues_dir}" || exit
# Download the dataset `smcalflow.full.data.tgz` or `smcalflow.inlined.data.tgz`
# The `PATH_TO_DATA_TGZ` is the path to the tgz file of the corresponding dataset.
unzip ../../datasets/SMCalFlow\ 2.0/train.dataflow_dialogues.jsonl.zip
unzip ../../datasets/SMCalFlow\ 2.0/valid.dataflow_dialogues.jsonl.zip