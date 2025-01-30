FROM python:3.11.5-slim-bullseye AS python


LABEL authors="Patrick Upson"

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




# Set work directory
#WORKDIR /opt/project

# Install dependencies
#COPY ./requirements.txt .
#RUN pip install -r requirements.txt

#RUN apt-get update && apt-get install -y binutils libproj-dev gdal-bin python3-gdal

# Copy project
#COPY . .
