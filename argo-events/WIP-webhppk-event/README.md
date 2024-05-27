curl -X POST \
  -d '{"image_tag":"v1.0.0"}' \
  -H "Content-Type: application/json" \
  https://argoevents.sosotechnologies.com/push



curl 'https://10.0.0.87:2746/api/v1/events/argo-events/-' \
  -H 'Content-Type: application/json' \
  -d '{"image_tag":"v1.0.0"}'


***Edit the service to virtual service***
kubectl -n argo-events get eventsources
kubectl -n argo-events edit svc ecr-webhook-eventsource-svc 
kubectl -n argo-events get po