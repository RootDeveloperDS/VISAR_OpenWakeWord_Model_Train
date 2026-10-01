@'
# Visar (वी-सार) — Edge Wake Word Model

Custom offline wake-word detection engine fine-tuned for Indian phonetics (Devanagari "वी-सार" / Indian English "Vee-saar").

## Accuracy & Evaluation
- **Accuracy:** 80.4%
- **Recall:** 61.2%
- **False Positives / Hour:** ~0.35 (Tested against 11 hours of real-world negative speech)
- **Acoustic Backbone:** Convolved with MIT Room Impulse Responses (RIRs) and calibrated against 96 ground-truth microphone samples.

## Repository Contents
- `models/`: Production runtime inference graphs (`visar_edge.onnx` and `visar_edge.tflite`).
- `src/`: Patched versions of `openwakeword` and `piper-sample-generator` (resolves Python 3.12+ `torchaudio` shims and PyTorch `weights_only` serialization).
- `data/my_real_voice/`: Raw calibration WAV audio files for model fine-tuning.
- `config/my_model.yaml`: Complete training recipe, step counts, and augmentation configuration.
- `notebooks/`: Complete end-to-end training notebook.
- `scripts/`: Environment bootstrapper and testing utilities.

## Full Model Weights & Checkpoints
Due to GitHub file size limits, the uncompressed step checkpoints and raw training bundle (306 MB) are hosted on Hugging Face:
🔗 **[RootDeveloperDS/Visar_OpenWakeWord_Model](https://huggingface.co/RootDeveloperDS/Visar_OpenWakeWord_Model)**
'@ | Out-File -FilePath README.md -Encoding utf8
