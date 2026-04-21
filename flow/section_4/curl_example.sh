#!/usr/bin/env bash
# Простой запрос к vLLM через OpenAI-совместимый API

MODEL="Qwen/Qwen2.5-0.5B-Instruct"

curl -s http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"$MODEL"'",
    "messages": [
      {
        "role": "user",
        "content": "Объясни, что такое батчинг в инференсе, за два предложения."
      }
    ],
    "max_tokens": 200,
    "temperature": 0.7
  }' | python3 -m json.tool
