dataflow_dialogues_dir="output/dataflow_dialogues_v1"
mkdir -p "${dataflow_dialogues_dir}"

cd "${dataflow_dialogues_dir}" || exit
# Download the dataset `smcalflow.full.data.tgz` or `smcalflow.inlined.data.tgz`
# The `PATH_TO_DATA_TGZ` is the path to the tgz file of the corresponding dataset.

wget "https://smresearchstorage.blob.core.windows.net/smcalflow-public/smcalflow.full.data.tgz"
tar -xvzf smcalflow.full.data.tgz