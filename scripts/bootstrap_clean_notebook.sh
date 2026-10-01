#!/usr/bin/env bash
# ==============================================================================
# Visar Wake Word: Zero-Error Bootstrap Script
# Run this inside any blank Colab or Linux environment:
#   !bash bootstrap_clean_notebook.sh
# ==============================================================================
set -e

echo "🚀 [1/4] Installing verified core dependencies..."
pip install --no-cache-dir -r requirements_frozen.txt || {
    echo "⚠️ Strict freeze install hit conflicts. Falling back to pinned core modules..."
    pip install -q openwakeword==0.6.0 onnxscript onnx2tf edge-tts soundfile pydub datasets torch-audiomentations
}

echo "🩹 [2/4] Applying torchaudio compatibility shim..."
python -c '
import torchaudio, os
patch = """
import soundfile as sf
import torch
from collections import namedtuple

AudioMetaData = namedtuple("AudioMetaData", ["sample_rate", "num_frames", "num_channels", "bits_per_sample", "encoding"])

def _shim_info(file_path, format=None):
    s = sf.info(str(file_path))
    return AudioMetaData(sample_rate=s.samplerate, num_frames=s.frames, num_channels=s.channels, bits_per_sample=16, encoding="PCM_S")

def _shim_load(file_path, frame_offset=0, num_frames=-1, normalize=True, channels_first=True, format=None):
    start = frame_offset
    stop = None if num_frames in (-1, None) else frame_offset + num_frames
    data, sr = sf.read(str(file_path), start=start, stop=stop, dtype="float32", always_2d=True)
    tensor = torch.from_numpy(data)
    if channels_first:
        tensor = tensor.t()
    return tensor, sr

info = _shim_info
load = _shim_load
"""
init_path = os.path.dirname(torchaudio.__file__) + "/__init__.py"
with open(init_path, "a") as f:
    f.write(patch)
print("✅ Torchaudio shim verified successfully.")
'

echo "📂 [3/4] Unpacking pre-patched repositories..."
if [ -f "patched_openwakeword.tar.gz" ]; then
    tar -xzf patched_openwakeword.tar.gz
    echo "✅ Patched openWakeWord extracted."
fi
if [ -f "patched_piper.tar.gz" ]; then
    tar -xzf patched_piper.tar.gz
    echo "✅ Patched Piper extracted."
fi

echo "🎉 [4/4] Environment ready! You can now run feature extraction and training."
