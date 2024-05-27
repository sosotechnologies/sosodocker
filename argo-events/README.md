# ArgoEvents
https://argoproj.github.io/argo-events/eventsources/setup/github/
https://argoproj.github.io/argo-events/sensors/triggers/argo-workflow/


## create argo-events namespace 
```sh
kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
```

## Creating event sources 
```sh
kubectl -n argo-events apply -f 1-event-source.yaml
kubectl -n argo-events apply -f 2-sensor.yaml
kubectl -n argo-events get eventsources
kubectl -n argo-events get svc
kubectl -n argo-events edit svc ecr-webhook-eventsource-svc 
kubectl -n argo-events get po
```

## curl  the service
```sh
curl -X POST \
  -d '{"image_tag":"v1.0.0"}' \
  -H "Content-Type: application/json" \
  http://10.0.0.89:12000/ecr-push
```

