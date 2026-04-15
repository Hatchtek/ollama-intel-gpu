# =============================================================================
# Self-Updating IPEX-LLM Ollama — Docker Image for Intel Arc GPUs
# =============================================================================
# This image uses the Intel base, but intercepts the boot process.
# Every time the container is started or restarted, it will forcefully download
# the absolute newest mainline Ollama binary before starting the engine.
# =============================================================================

FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# ---------------------------------------------------------------------------
# Configure runtime environment
# ---------------------------------------------------------------------------
ENV OLLAMA_NUM_GPU=999
ENV ZES_ENABLE_SYSMAN=1
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
ENV no_proxy=localhost,127.0.0.1

# Ollama standard Unraid template settings
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_NUM_PARALLEL=1
ENV OLLAMA_KEEP_ALIVE=10m

EXPOSE 11434
VOLUME ["/root/.ollama"]

# ---------------------------------------------------------------------------
# The Auto-Update Entrypoint
# ---------------------------------------------------------------------------
# 1. Download the newest Ollama Linux binary directly over the existing one.
# 2. Make it executable.
# 3. Source the Intel oneAPI driver variables.
# 4. Hand off the process to the newly downloaded Ollama server.
ENTRYPOINT ["/bin/bash", "-c", "curl -fsSL https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama && chmod +x /usr/bin/ollama && source /opt/intel/oneapi/setvars.sh && exec ollama serve"]
