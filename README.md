
# Developer Use Guide

## Up Laboratory database for debug in IDE
```bash
docker-compose up -d db
docker logs my-flask-app-db
```
![](img/dockerCompose.png)

## Build Image
```bash
$ VERSION=0.0.1
$ docker build -t flask-app:$VERSION .
$ docker-compose up -d app
```
![](img/dockerBuild.png)
![](img/dockerCompose2.png)


## Create Docker container and test app
```bash
$ curl localhost:5001
```
![](img/curl.png)

## DockerHub Login 
```bash
$ docker login --username contrerasadr --password ****
 username: contrerasadr
 password: ******
```
![](img/dockerLogin.png)

## Subir imágen docker de la app a Docker Hub
```bash
$ docker tag flask-app:0.0.1 contrerasadr/devops-training-flask-app:0.0.1
$ docker push contrerasadr/devops-training-flask-app:0.0.1
```

```
$ cat ~/.docker/config.json 
```

## Push
```bash
$ docker tag 
$ docker push contrerasadr/scalian_training/my-flask-app:0.0.1
```
![](img/dockerTag.png)

![](img/dockerhub.png)


## Clear
```bash
$ docker-compose down 
$ docker volume rm devops-training-python-project_dbdata 
```
![](img/composeDown.png)

![](img/volumenRm.png)

