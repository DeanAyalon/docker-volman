FROM python:3.12-slim-bookworm AS tools

WORKDIR /app

RUN pip install pipx && pipx install poetry && pipx ensurepath
ENV PATH="$PATH:/root/.local/bin" \
    POETRY_VIRTUALENVS_CREATE=false

COPY pyproject.toml poetry.lock ./
RUN poetry install

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker

COPY run.py .

ENTRYPOINT ["python3", "run.py"]