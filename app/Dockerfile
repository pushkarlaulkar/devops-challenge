# Using a lightweight Python image
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy only necessary files
COPY server.py requirements.txt ./

# Install dependencies using pip3
RUN pip3 install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 80

# Run the Flask app
CMD ["python3", "server.py"]