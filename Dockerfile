from ubuntu:latest
MAINTAINER Gabriel Vinha "gabriel.vinha@outlook.com"

#Instala pip + python dependencias
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    libcurl4-openssl-dev \
    libgnutls-dev \
    libssl-dev

RUN pip install --upgrade pip

#Define diretorio onde a aplicacao vai rodar
COPY . /app
WORKDIR /app

#Instala dependencias do flask
RUN pip install -r requirements.txt

EXPOSE 8080

#Sobe o app :)
ENTRYPOINT ["python"]
CMD ["app.py"]
