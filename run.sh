#!/bin/bash
. env.sh
COMMAND=$1

if [ ! -x "$(which docker 2>/dev/null)" ]; then
    echo "Cannot execute docker command."
    echo "Aborting."
    exit 1
fi
if [ -f "$KONG_LICENSE_FILE" ]; then
    export KONG_LICENSE_DATA=$(cat $KONG_LICENSE_FILE)
fi

function all_start()
{
    if [ ! -d "config/grafana/grafana-tempo/tempo-data" ]; then
        mkdir -p config/grafana/grafana-tempo/tempo-data
    fi
    docker-compose up -d 
    echo "Waiting for Kong Admin API to be ready..."
    while ! curl -s -o /dev/null -w "%{http_code}" http://localhost:8001/status | grep -q 200; do
        echo "Kong Admin API is not ready yet. Waiting 5 seconds..."
        sleep 5
    done
    echo "Kong Admin API is ready!"
    deck gateway sync ./config/deck/sample.yaml
}

function all_stop()
{
    docker-compose down --volumes --remove-orphans
}

case "$COMMAND" in
    "stop")
        all_stop
        ;;
    "restart")
        all_stop
        all_start
        ;;
    "start")
        all_start
        ;;
    "test")
        curl -i http://localhost:8000/httpbin/anything
        open http://localhost:3000
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Usage: $0 {start|stop|restart|test}"
        exit 1
        ;;
esac