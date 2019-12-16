#!/bin/bash

ARGS=()
MLFLOW_TRACKING_URI=${MLFLOW_TRACKING_URI:-http://mlflow.local/}
export MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--experiment)
    EXPERIMENT="$2"
    shift; shift;
    ;;
    -n|--notebook)
    NOTEBOOK="$2"
    shift; shift;
    ;;
    *)    # unknown option
    ARGS+=("$1")
    shift;
    ;;
esac
done

[[ -z "$NOTEBOOK" ]] && { echo "Notebook argument not supplied"; exit 1; }  # Exit if no arguments!
[[ -z "$EXPERIMENT" ]] && { echo "Experiment argument not supplied"; exit 1; }  # Exit if no arguments!

if [[ ! -f "$NOTEBOOK" ]]; then
    echo "$NOTEBOOK doesn't exist"
    exit 1
fi

mlflow experiments list | grep -w $EXPERIMENT > /dev/null
if [[ $? -ne 0 ]]; then
    echo "$EXPERIMENT doesn't exist in mlflow"
    mlflow experiments list
    exit 1
fi


COMMAND="mlflow run . -e main"
COMMAND="$COMMAND -b kubernetes --backend-config scripts/mlflow-kubernetes-configuration.json --experiment-name $EXPERIMENT"

# Add notebook path
COMMAND="$COMMAND -P input=${NOTEBOOK} -P output=output_$(basename ${NOTEBOOK})"
# Add argument
for arg in "${ARGS[@]}"
do
   COMMAND="$COMMAND -P $arg"
   # or do whatever with individual element of the array
done

echo "Using MLFLOW_TRACKING_URI: ${MLFLOW_TRACKING_URI}"
echo "Starting command: $COMMAND"

$COMMAND
