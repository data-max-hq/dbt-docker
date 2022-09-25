FROM python:3.9.13

# Update and install system packages
RUN apt-get update -y && \
  apt-get install --no-install-recommends -y -q \
  git libpq-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set environment variables
ENV DBT_DIR /dbt

# Set working directory
WORKDIR $DBT_DIR

# Copy requirements
COPY requirements.txt .

# Install DBT
RUN pip install -U pip
RUN pip install -r requirements.txt

RUN mkdir dbt_demo
COPY dbt_demo/dbt_project.yml ./dbt_demo
RUN ["dbt", "deps", "--project-dir", "./dbt_demo"]
COPY dbt_demo ./dbt_demo

# Run dbt
# CMD ["dbt", "run"]