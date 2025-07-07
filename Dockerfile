# Use an official Ubuntu LTS image as base
FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install gcc, g++, make, and other dev tools
RUN apt-get update && \
    apt-get install -y gcc g++ make build-essential \
    git curl wget nano vim \
    && rm -rf /var/lib/apt/lists/*

# Set the work directory (optional)
WORKDIR /workspace

# Optionally: copy your VajaCompiler files in if you want them in the image
COPY VajaCompiler /workspace
COPY test.vaja /workspace

# Default command (bash shell)
CMD ["/bin/bash"]
