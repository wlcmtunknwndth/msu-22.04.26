#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_REPO="$SCRIPT_DIR/model_repository"
ONNX_SRC="$SCRIPT_DIR/../../section_2/outputs/resnet18_cifar10.onnx"
ONNX_DST="$MODEL_REPO/resnet18_cifar10/1/model.onnx"

echo "Copying ONNX model..."
cp "$ONNX_SRC" "$ONNX_DST"
echo "  $ONNX_SRC"
echo "  -> $ONNX_DST"

echo ""
echo "Starting Triton Inference Server..."
echo "  HTTP  → http://localhost:8000"
echo "  gRPC  → localhost:8001"
echo "  Metrics → http://localhost:8002/metrics"
echo ""

docker run --rm \
  --platform linux/amd64 \
  -p 8000:8000 \
  -p 8001:8001 \
  -p 8002:8002 \
  -v "$MODEL_REPO":/models \
  nvcr.io/nvidia/tritonserver:24.05-py3 \
  tritonserver --model-repository=/models
