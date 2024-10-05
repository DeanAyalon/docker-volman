FROM python:3.12-slim-bookworm AS deps

WORKDIR /app

# Install poetry and add to path
RUN pip install pipx && pipx install poetry && pipx ensurepath
RUN python3 -m venv --without-pip .venv
ENV PATH="/app/.venv/bin:$PATH:/root/.local/bin"
    # POETRY_VIRTUALENVS_CREATE=false

# Virtual environment
# RUN . .venv/bin/activate

# Python dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install

# Docker CLI
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker

COPY run.py .

ENTRYPOINT ["python3", "run.py"]