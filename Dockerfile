# Use an official Ubuntu LTS image as base
FROM ubuntu:24.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install gcc, g++, make, and other dev tools
RUN apt-get update && \
    apt-get install -y gcc g++ make build-essential \
    git curl wget nano vim sudo \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:dotnet/backports && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0

# Create vscode user with passwordless sudo (devcontainer standard)
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_vscode \
    && chmod 0440 /etc/sudoers.d/99_vscode

# Set workdir (optional, matches devcontainer default)
WORKDIR /workspace
