# ArgoEvents
https://argoproj.github.io/argo-events/eventsources/setup/github/
https://argoproj.github.io/argo-events/sensors/triggers/argo-workflow/


## create argo-events namespace CRD and Eventbus
```sh
kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
```

## Creating event sources and sensor
[- The eventSources can be found here](https://github.com/argoproj/argo-events/blob/master/api/event-source.md#githubeventsource)
[- The github example](https://argoproj.github.io/argo-events/eventsources/setup/github/#)

### GitHUB event sources 

```sh
kubectl -n argo-events apply -f 1-event-source.yaml
kubectl -n argo-events get svc

***Edit the service to virtual service***

kubectl -n argo-events apply -f 2-sensor.yaml
kubectl -n argo-events get eventsources
kubectl -n argo-events edit svc ecr-webhook-eventsource-svc 
kubectl -n argo-events get po
```

## curl  the service  with just load balancer
```sh
curl -X POST \
  -d '{"image_tag":"v1.0.0"}' \
  -H "Content-Type: application/json" \
  http://10.0.0.89:12000/ecr-push
```

## curl the service if you configured virtual service
```sh
curl -X POST \
  -d '{"image_tag":"v1.0.0"}' \
  -H "Content-Type: application/json" \
  https://argoevents.sosotechnologies.com/ecr-push
```

kubectl config view --minify -o 'jsonpath={.clusters[0].cluster.server}'