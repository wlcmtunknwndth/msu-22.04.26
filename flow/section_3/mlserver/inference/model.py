from pathlib import Path

import numpy as np
import onnxruntime as ort
from mlserver import MLModel
from mlserver.types import InferenceRequest, InferenceResponse, ResponseOutput


class ONNXModel(MLModel):
    async def load(self) -> bool:
        model_path = Path(self.settings.parameters.uri)
        self._session = ort.InferenceSession(
            str(model_path), providers=["CPUExecutionProvider"]
        )
        self._input_name  = self._session.get_inputs()[0].name
        self._output_name = self._session.get_outputs()[0].name
        return await super().load()

    async def predict(self, payload: InferenceRequest) -> InferenceResponse:
        inp   = payload.inputs[0]
        data  = np.array(inp.data, dtype=np.float32).reshape(inp.shape)
        out   = self._session.run([self._output_name], {self._input_name: data})[0]

        return InferenceResponse(
            id=payload.id,
            model_name=self.name,
            outputs=[
                ResponseOutput(
                    name=self._output_name,
                    shape=list(out.shape),
                    datatype="FP32",
                    data=out.flatten().tolist(),
                )
            ],
        )
