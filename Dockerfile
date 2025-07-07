# Use an official Ubuntu LTS image as base
FROM ubuntu:24.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install gcc, g++, make, and other dev tools
RUN apt-get update && \
    apt-get install -y gcc g++ make build-essential \
    git curl wget nano vim \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN add-apt-repository ppa:dotnet/backports && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0