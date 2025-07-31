FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY main.py .

# Set environment variables at runtime
# via ECS task definition, not here

# Run your app
CMD ["python", "main.py"]
