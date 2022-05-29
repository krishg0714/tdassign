# Solution to the assignment problem

*******************************************************************************************

## **Phase 1: Containerize the application and check it locally**

1. Created Dockerfile code for running the Python application in container

2. Created multi container Docker compose file

3. Install the docker compose setup on your machine, and run following command

  docker compose up -d  

4. Checked the url on http://3.145.100.120:8080/

5. Check if all the containers are up

docker ps

```
docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED             STATUS             PORTS                                       NAMES
582a82a1c40d   tdassign_web   "python3 ./flaskmicr…"   About an hour ago   Up About an hour   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   tdassign-web-1
6c74062a6fc2   redis          "docker-entrypoint.s…"   About an hour ago   Up About an hour   6379/tcp                                    tdassign-redis-1

```

6. Check if the logs are clean

docker logs -f 582a82a1c40d 

```
[root@ip-10-0-1-118 tdassign]# docker logs -f 582a82a1c40d
 * Serving Flask app 'flaskmicroservice' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Running on all addresses (0.0.0.0)
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://127.0.0.1:8080
 * Running on http://172.20.0.3:8080 (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 378-670-508
103.59.74.35 - - [29/May/2022 16:34:36] "GET / HTTP/1.1" 200 -
103.59.74.35 - - [29/May/2022 16:34:37] "GET /favicon.ico HTTP/1.1" 404 -
103.59.74.35 - - [29/May/2022 16:34:39] "GET / HTTP/1.1" 200 -
192.241.221.239 - - [29/May/2022 17:17:10] "GET / HTTP/1.1" 200 -
45.148.10.81 - - [29/May/2022 17:27:57] code 400, message Bad request syntax ('\x04\x01\x00Ph\x12sa\x00')
45.148.10.81 - - [29/May/2022 17:27:57] "Phsa" HTTPStatus.BAD_REQUEST -
103.59.74.35 - - [29/May/2022 17:28:01] "GET / HTTP/1.1" 200 -

``` 


************************************************************************************************


## **Phase 2: Convert the docker compose artifact to Kubernetes object**

1. Installed kompose using https://kompose.io/ 

2. Executed command kompose convert -f docker-compose.yml 

```
kompose convert -f docker-compose.yml
WARN Unsupported depends_on key - ignoring
WARN Volume mount on the host "." isn't supported - ignoring path on the host
INFO Kubernetes file "redis-service.yaml" created
INFO Kubernetes file "web-service.yaml" created
INFO Kubernetes file "redis-deployment.yaml" created
INFO Kubernetes file "web-deployment.yaml" created
INFO Kubernetes file "web-claim0-persistentvolumeclaim.yaml" created

```


************************************************************************************************

## **Phase 3: Adding the Probes**

1. In the web-deployment and redis-deployment added the section fo readyness and livness proble 

For Redis added TCP Port probe
```
  containers:
      - image: redis
        name: redis
        livenessProbe:
          tcpSocket:
            port: 6439
          initialDelaySeconds: 3
          periodSeconds: 3

```

2. For Flask web added httpGet probe

```
     livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 3

```
 

***************************************************************************************************

## **Phase 4: Secret Management**

We can use Kubernetes secret service for confidential information and mount it using config map

Else, we can consider using AWS secrets manager where containers are fetching information at run time using API
