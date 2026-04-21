#!/usr/bin/env bash
# Запускает MLServer через Docker (onnxruntime уже включён в образ)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONNX_SRC="$SCRIPT_DIR/../../section_2/outputs/resnet18_cifar10.onnx"
ONNX_DST="$SCRIPT_DIR/inference/model.onnx"

echo "Copying ONNX model..."
cp "$ONNX_SRC" "$ONNX_DST"
echo "  $ONNX_SRC"
echo "  -> $ONNX_DST"

echo ""
echo "Starting MLServer via Docker..."
echo "  HTTP    → http://localhost:8080"
echo "  gRPC    → localhost:8081"
echo ""

docker run --rm \
  -p 8080:8080 \
  -p 8081:8081 \
  -v "$SCRIPT_DIR/inference":/mnt/models \
  seldonio/mlserver:1.3.5 \
  mlserver start /mnt/models
