FROM python:3.12-slim-bookworm AS base
WORKDIR /app

FROM base AS deps

# Install poetry, create venv and add to path
RUN pip install pipx && pipx install poetry && pipx ensurepath
RUN python3 -m venv --without-pip .venv
ENV PATH="/app/.venv/bin:$PATH:/root/.local/bin"

# Python dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install

FROM base
ENV PATH="/app/.venv/bin:$PATH"

# Docker CLI
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker

# Dependencies
COPY --from=deps /app/.venv ./.venv

# Script
COPY run.py .

ENTRYPOINT ["python3", "run.py"]