FROM python:3.11.5-slim-bullseye AS python
FROM cgr.dev/chainguard/python@sha256:52820d1718fe1263cb8459cf7db1b136bcdf4758ac7f6dff7599d309ebd3eaf8 AS final

LABEL authors="Patrick Upson"
LABEL authors="John Bain"

FROM python AS requirements

WORKDIR /opt/project

ENV VENV_PATH="/opt/project/venv"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1 
ENV LANG=C.UTF-8
ENV PATH="$VENV_PATH/bin:$PATH"

COPY requirements.txt .

RUN python -m venv $VENV_PATH && \
    $VENV_PATH/bin/pip install \
        --no-cache-dir \
        --use-pep517 \
        --requirement requirements.txt && \
    rm -rf requirements.txt

FROM final

ENV LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=/home/site/wwwroot \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/project/venv/bin:$PATH"

COPY --from=requirements /opt/project/venv /opt/project/venv


# Set work directory
WORKDIR /opt/project

# Install dependencies
#COPY ./requirements.txt .
#RUN pip install -r requirements.txt

#RUN apt-get update && apt-get install -y binutils libproj-dev gdal-bin python3-gdal

# Copy project
COPY . .

HEALTHCHECK CMD curl --fail http://localhost:80/health || exit 1

EXPOSE 00