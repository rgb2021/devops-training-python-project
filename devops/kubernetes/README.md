
# Practica, desplegar My Flask App en kubernetes


## Preparar entorno

```bash
# FREE Persistent volume
$ kubectl delete job bash-example-with-vol -n ejercicio1
$ kubectl delete pvc -n ejercicio1 bash-example-logs-pvc
$ kubectl delete pv local-pv-volume
$ kubectl apply -f ../local-persistent-volume.yaml
# Namespace
$ kubectl apply -f 0_namespace.yaml
```

## Instalar DB

```bash
# Config
$ kubectl apply -n practica -f 1_database-config.yaml
$ kubectl apply -n practica -f 2_database-root-user-secret.yaml 
# PV Claim
$ kubectl apply -n practica -f 3_database-pvc.yaml
$ kubectl get pvc -n practica # Should be bounded
# Deployment
$ kubectl apply -n practica -f 4_database-deployment.yaml
$ kubectl get deployment -n practica
$ kubectl describe deployment database-dep
$ kubectl get pods -n practica -l app=database

$ kubectl logs -n practica <POD_NAME>
$ kubectl logs -n practica -l app=database
$ kubectl exec -n practica -l app=database -- cat docker-entrypoint-initdb.d/initdb.sql



# Service
$ kubectl apply -n practica -f 5_database-service.yaml

# Testing DB
$ kubectl run -it --rm --image=mysql:5.7  -n practica --restart=Never mysql-client -- mysql -h database-svc.practica -u root -proot

```

## Instalar APP
```bash
$ kubectl apply -n practica -f 6_my-app-deployment.yaml
$ kubectl describe deployment my-flask-app-dep
$ kubectl get pods -n practica -l app=my-flask-app
$ kubectl logs -n practica -l app=my-flask-app
```

## Instalar APP Service
```bash
$ kubectl apply -n practica -f 7_my-app-service.yaml
## TTI curl service
$ kubectl run mycurlpod -n practica --image=curlimages/curl -i --tty -- sh
# RUN curl to service
$ kubectl run mycurlpod -n practica --image=curlimages/curl  --restart=Never -- curl my-flask-app-svc.practica:5000

# INGRESS

# NODEPORT
$ kubectl apply -n practica -f 9_my-app-nodeport.yaml


```


