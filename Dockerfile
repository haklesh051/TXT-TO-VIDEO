# Use a supported Python base image (Bookworm)
FROM python:3.10-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    ffmpeg \
    aria2 \
    musl-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy project files
COPY . /app/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir pytube

# Set environment variable
ENV COOKIES_FILE_PATH="/app/youtube_cookies.txt"

# Run gunicorn (web app) and main.py (background worker) together
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:8000 app:app & python3 main.py"]
