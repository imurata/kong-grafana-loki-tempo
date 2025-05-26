## How to use
1. Boot Kong Gateway, Prometheus, Grafana, Loki, Tempo, etc
```sh
./run.sh start
```
It wrap `docker-compose up` and configure Kong Gateway's Service/Route/Plugin.
Multiple containers are launched after running the command, and each can be accessed as follows.
|Service|Host|
|---|---|
|Kong Gateway|http://localhost:8002|
|Prometheus|http://localhost:9090|
|Grafana|http://localhost:3000|
|httpbin (via GW)|http://localhost:8000/httpbin|

2. Run API requests
Send an API Request and record metrics, logs, and tracings by doing the following.
```sh
./run.sh test
```


