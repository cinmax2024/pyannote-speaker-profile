FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime

# OS deps for pyannote audio loading + huggingface model cache
RUN apt-get update && apt-get install -y --no-install-recommends \
      ffmpeg libsndfile1 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pre-cache python deps in their own layer for faster rebuilds
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .

# RunPod serverless entry: handler.py ends with
#   runpod.serverless.start({"handler": handler})
# which makes this a proper serverless worker.
CMD ["python", "-u", "handler.py"]
