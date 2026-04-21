#!/usr/bin/env bash
# vLLM в Docker с NVIDIA GPU: Linux + Docker с nvidia-container-toolkit (`--gpus all`).
# На macOS GPU в контейнер не пробрасывается — для локального демо см. run_vllm_docker.sh (CPU).
set -euo pipefail

MODEL="${VLLM_MODEL:-Qwen/Qwen2.5-0.5B-Instruct}"
HF_CACHE="${HF_HOME:-$HOME/.cache/huggingface}"
HOST_PORT="${VLLM_HOST_PORT:-8000}"
VLLM_IMAGE="${VLLM_DOCKER_IMAGE:-vllm/vllm-openai:latest}"

echo "Starting vLLM via Docker (NVIDIA GPU)..."
echo "  Model      : $MODEL"
echo "  Image      : $VLLM_IMAGE"
echo "  Cache      : $HF_CACHE"
echo "  Host port  : $HOST_PORT → container 8000"
echo "  API        → http://localhost:${HOST_PORT}/v1"
echo ""

docker run --rm \
  --gpus all \
  --shm-size=8g \
  -p "${HOST_PORT}:8000" \
  -v "$HF_CACHE":/root/.cache/huggingface \
  "$VLLM_IMAGE" \
  --model "$MODEL" \
  --max-model-len 2048 \
  --dtype auto
