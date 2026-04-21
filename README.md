# ML Inference Workshop

Small workshop repo about ML inference: from a trained PyTorch model to ONNX, inference servers, and LLM serving.

## Contents

- `Plan.md` — workshop outline and timing
- `PRESENTATION.md` — slide deck source
- `flow/section_2/` — train `ResNet-18` on CIFAR-10 and export to ONNX
- `flow/section_3/` — serve the same ONNX model with MLServer and Triton
- `flow/section_4/` — compare naive HuggingFace inference with vLLM

## Setup

Create and activate a virtual environment, then install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Docker is required for the server demos in `section_3` and `section_4`.

## Suggested order

1. Open `flow/section_2/resnet18_cifar10.ipynb`.
   Train the model and export `resnet18_cifar10.onnx`.
2. Run one inference server from `flow/section_3/`:
   - `flow/section_3/mlserver/run_mlserver_docker.sh`
   - `flow/section_3/triton/run_triton.sh`
3. Open `flow/section_3/client.ipynb` and compare latency / throughput.
4. For LLM inference, use `flow/section_4/`:
   - `run_vllm_docker.sh` for CPU-friendly local runs
   - `run_vllm_docker_gpu.sh` for NVIDIA GPU runs
   - `vllm_demo.ipynb` and `curl_example.sh` for testing

## Notes

- MLServer uses port `8080` in this repo.
- Triton and vLLM use port `8000` by default, so avoid running them at the same time unless you remap ports.
- On macOS, the CPU vLLM script is the safe default. GPU vLLM requires Linux + NVIDIA container runtime.

## Presentation

Build the PDF slides with:

```bash
make presentation
```
