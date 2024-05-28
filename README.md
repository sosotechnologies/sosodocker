# ArgoEvents
https://argoproj.github.io/argo-events/eventsources/setup/github/
https://argoproj.github.io/argo-events/sensors/triggers/argo-workflow/


## create argo-events namespace CRD and Eventbus
```sh
kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
```

## create githun PAT and deploy as a k8s secret

```sh
echo -n github_pat_11xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx | base64
```

```yml
apiVersion: v1
kind: Secret
metadata:
  name: github-access
type: Opaque
data:
  token: Z2l0aHViX3BhdF8xMUEzNFxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

```sh
kubectl -n argo-events apply -f github-secret.yaml
```

## Create a virtual service

```sh
kubectl apply -f argo-event-vs.yaml
```

## Creating event sources and sensor
[- The eventSources can be found here](https://github.com/argoproj/argo-events/blob/master/api/event-source.md#githubeventsource)
[- The github example](https://argoproj.github.io/argo-events/eventsources/setup/github/#)

### GitHUB event sources 

```sh
kubectl -n argo-events apply -f 0-event-source-Github.yaml
kubectl -n argo-events get svc

***Edit the service to virtual service***

kubectl -n argo-events apply -f 2-sensor.yaml
kubectl -n argo-events get eventsources
kubectl -n argo-events edit svc ecr-webhook-eventsource-svc 
kubectl -n argo-events get po
```

## create argo-workflows-access-token
[LINK:](https://argo-workflows.readthedocs.io/en/latest/access-token/)

### Firstly, create a role with minimal permissions. This example role for sosogit only permission to update and list workflows:
kubectl -n argo create role sosogit --verb=get,list,watch,create,update,patch,delete --resource=workflows.argoproj.io

### Create a service account for your service:
kubectl -n argo create sa sosogit

### Bind the service account to the role (in this case in the argo namespace):
kubectl -n argo create rolebinding sosogit --role=sosogit --serviceaccount=argo:sosogit

### Token Creation
```sh
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: sosogit.service-account-token
  annotations:
    kubernetes.io/service-account.name: sosogit
type: kubernetes.io/service-account-token
EOF
```

### Wait a few seconds:

```sh
ARGO_TOKEN="Bearer $(kubectl -n argo get secret sosogit.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"

echo $ARGO_TOKEN

curl https://10.0.0.89:2746/api/v1/workflows/argo -H "Authorization: $ARGO_TOKEN" --insecure 

curl https://10.0.0.89:2746/workflow-templates?namespace=argo -H "Authorization: $ARGO_TOKEN" --insecure 
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


curl -X POST \
  -d '{"image_tag":"v1.0.0"}' \
  -H "Content-Type: application/json" \
  https://argoevents.sosotechnologies.com/push


## ORRRRRRRRR
### Firstly, create a role with minimal permissions. This example role for sosogit only permission to update and list workflows:
```sh
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: argo
  name: argo-role
rules:
- apiGroups: ["argoproj.io"]
  resources: ["workflows", "workflowtemplates"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
EOF
```

### Create a service account for your service:
kubectl create sa sosogit -n argo

### Bind the service account to the role (in this case in the argo namespace):

```sh
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-rolebinding
  namespace: argo
subjects:
- kind: ServiceAccount
  name: sosogit
  namespace: argo
roleRef:
  kind: Role
  name: argo-role
  apiGroup: rbac.authorization.k8s.io
EOF
```

### Token Creation
```sh
kubectl delete -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: sosogit.service-account-token
  annotations:
    kubernetes.io/service-account.name: sosogit
type: kubernetes.io/service-account-token
EOF
```

### Wait a few seconds:

```sh
ARGO_TOKEN="Bearer $(kubectl -n argo get secret sosogit.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"

echo $ARGO_TOKEN

curl https://10.0.0.89:2746/api/v1/workflows/argo -H "Authorization: $ARGO_TOKEN" --insecure 

curl https://10.0.0.89:2746/workflow-templates?namespace=argo -H "Authorization: $ARGO_TOKEN"