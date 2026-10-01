# Visar Wake Word — Reproducibility Runbook

## Why This Package Exists
Upstream openWakeWord relies on legacy packages that break in modern Python / PyTorch environments:
1. `torchaudio`: Removed `set_audio_backend()` and `.info()` (patched via soundfile shim).
2. PyTorch: Enforces `weights_only=True` by default (patched in Piper generator).
3. DeepPhonemizer: AWS S3 CMU dict bucket throws HTTP 403 (patched with offline Indian + English phonetic pool).
4. Hugging Face Datasets: Removed script execution (`fma.py` / AudioSet tar dead links patched via ESC-50).
5. Exporter: Legacy `onnx_tf` replaced with modern `onnx2tf`.

## How to Retrain From Scratch on a Fresh Colab:
1. Upload this archive and extract:
   `tar -xzf visar_training_pipeline_source.tar.gz`
2. Extract the pre-patched engines:
   `tar -xzf patched_openwakeword.tar.gz`
   `tar -xzf patched_piper.tar.gz`
3. Install core dependencies:
   `pip install -q openwakeword torch-audiomentations datasets webrtcvad-wheels onnxscript onnx2tf edge-tts pydub soundfile`
4. Populate `my_real_voice/` with any new audio recordings.
5. Re-run feature extraction and training:
   `python openwakeword/openwakeword/train.py --training_config my_model.yaml --train_model`
