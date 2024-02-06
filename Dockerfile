FROM python:3.6-slim

#EXPOSE 5000

WORKDIR /app

COPY requirements.txt /app
RUN pip install -r requirements.txt

COPY src /app/src
WORKDIR /app/src

CMD python app.py