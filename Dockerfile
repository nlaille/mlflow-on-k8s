FROM jupyter/tensorflow-notebook:latest

# Start jupyterlab
ENV JUPYTER_ENABLE_LAB yes
# Set MLFLOW_TRACKING_URI to local
ENV MLFLOW_TRACKING_URI "/home/jovyan/mlruns"

# Install requirements (papermill, mlflow, ...)
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN conda install psycopg2