FROM python:3.10-slim
WORKDIR /opt/dagster
COPY . .

RUN pip install -r requirements.txt

# Set DAGSTER_HOME here or in docker-compose
ENV DAGSTER_HOME=/opt/dagster/dagster_home

CMD ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000", "-f", "/opt/dagster/definitions.py"]
