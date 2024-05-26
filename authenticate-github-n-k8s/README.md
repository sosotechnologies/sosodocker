k create ns github

kubectl -n github create secret docker-registry github-container-registry \
    --docker-server=ghcr.io \
    --docker-username=sosotechnologies \
    --docker-password=xxxxxxx$$ \
    --dry-run=client -o yaml > github-secret.yaml

kubectl create secret generic aws-ecr-secret \
  --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
  --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY