# Use an official lightweight Python image.
FROM python:3.11-slim

# Set environment variables:
# 1. Prevent Python from writing .pyc files to disk
# 2. Ensure stdout and stderr are unbuffered (crucial for container logging)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy requirements first to leverage Docker's layer cache.
# Only re-installs dependencies if requirements.txt changes.
COPY requirements.txt .

# Install dependencies. We include gunicorn here since it is the production server.
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Copy the rest of the application code.
COPY . .

# The application listens on port 8080.
EXPOSE 8080

# Run Gunicorn. Adjust 'app:app' if your entry point file or Flask instance name differs.
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "8", "--timeout", "0", "app:app"]