#!/usr/bin/env bash
# vLLM на macOS запускается через Docker (нативная сборка требует Linux)
# Образ vllm/vllm-openai — CUDA-сборка: в Docker на Mac нет GPU → «Failed to infer device type».
# Нужен CPU-образ: https://docs.vllm.ai/en/latest/getting_started/installation/cpu/
set -euo pipefail

MODEL="Qwen/Qwen2.5-0.5B-Instruct"
HF_CACHE="${HF_HOME:-$HOME/.cache/huggingface}"

case "$(uname -m)" in
  arm64|aarch64)
    DOCKER_PLATFORM="linux/arm64"
    VLLM_IMAGE="${VLLM_DOCKER_IMAGE:-vllm/vllm-openai-cpu:latest-arm64}"
    ;;
  *)
    DOCKER_PLATFORM="linux/amd64"
    VLLM_IMAGE="${VLLM_DOCKER_IMAGE:-vllm/vllm-openai-cpu:latest-x86_64}"
    ;;
esac

# Docker Desktop (macOS) часто не отдаёт NUMA в контейнер → пустой список узлов и падение
# cpu_worker при VLLM_CPU_OMP_THREADS_BIND=auto. nobind — рекомендуемый режим для таких сред.
VLLM_CPU_OMP_THREADS_BIND="${VLLM_CPU_OMP_THREADS_BIND:-nobind}"

echo "Starting vLLM via Docker (CPU image)..."
echo "  Model    : $MODEL"
echo "  Image    : $VLLM_IMAGE"
echo "  Platform : $DOCKER_PLATFORM"
echo "  OMP bind  : $VLLM_CPU_OMP_THREADS_BIND"
echo "  Cache    : $HF_CACHE"
echo "  API      → http://localhost:8000/v1"
echo ""

docker run --rm \
  --platform "$DOCKER_PLATFORM" \
  --shm-size=4g \
  --cap-add SYS_NICE \
  --security-opt seccomp=unconfined \
  -e VLLM_CPU_OMP_THREADS_BIND="$VLLM_CPU_OMP_THREADS_BIND" \
  -p 8000:8000 \
  -v "$HF_CACHE":/root/.cache/huggingface \
  "$VLLM_IMAGE" \
  --model "$MODEL" \
  --max-model-len 2048 \
  --dtype float32
