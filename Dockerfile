# syntax=docker/dockerfile:1

#==============================================================================#
#========= Base Image =========#
#==============================================================================#
# Use slim, up-to-date, and official LTS version as base.
ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim-bookworm AS base

# Set environment variables for Python, pip, and Poetry.
ENV PYTHONUNBUFFERED=1 \
    # base path used by python to search for modules
    PROJECT_ROOT="/workspaces/ai" \
    # Pip configuration
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # Poetry configuration
    # Official Poetry documentation: https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=2.1.2 \
    # Make Poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # Do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    # Never create virtual environment automatically, only use environment prepared by us
    POETRY_VIRTUALENVS_CREATE=false \
    \
    # This is where our requirements + virtual environment will live
    VIRTUAL_ENV="/venv"

# Prepend Poetry and venv to path.
ENV PATH="$POETRY_HOME/bin:$VIRTUAL_ENV/bin:$PATH"

# append base python path to python path
ENV PYTHONPATH="$PROJECT_ROOT:$PYTHONPATH"

# Working directory
WORKDIR /workspace

# Install system dependencies.
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry - respects $POETRY_VERSION & $POETRY_HOME.
# The --mount will mount the buildx cache directory to where
# Poetry and Pip store their cache so that they can reuse it.
RUN --mount=type=cache,target=/root/.cache \
    curl -sSL https://install.python-poetry.org | python3 -

# Prepare virtual environment.
RUN python -m venv $VIRTUAL_ENV

RUN echo "Base image built successfully"


#==============================================================================#
#========= Dependency Image =========#
#==============================================================================#
FROM base AS deps

# Used to initialize dependencies.
COPY poetry.lock pyproject.toml ./

# Install runtime dependencies to VIRTUAL_ENV.
RUN --mount=type=cache,target=/root/.cache \
    poetry install --no-root --only main

RUN echo "Dependency image built successfully"


#==============================================================================#
#========= Development Image =========#
#==============================================================================#
FROM base AS dev

# Specify environment.
ENV ENVIRONMENT="development"

# Used to initialize dependencies.
COPY poetry.lock pyproject.toml ./

# Quicker install as runtime dependencies are already installed.
RUN --mount=type=cache,target=/root/.cache \
    poetry install --no-root

RUN echo "Development image built successfully"


