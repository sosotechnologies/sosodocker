name: Build and Push Docker Image to ECR

on: 
  push: 
    branches: [ "master" ]

jobs:
  build-and-push:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest  
    steps:
      - name: Checkout
        uses: actions/checkout@v2    

      - name: Setup AWS ECR Details
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-pf-aws-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Fetch Git Tags
        run: git fetch --tags

      - name: Bump Version
        run: |
          chmod +x ./bump-version.sh
          ./bump-version.sh

      - name: Build and push image Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-pf-aws-ecr.outputs.registry }}
          ECR_REPOSITORY: ${{ secrets.AWS_ECR_REPO }}
          IMAGE_TAG: ${{ env.NEW_VERSION }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          
      # - name: Setup kubectl
      #   uses: azure/k8s-set-context@v2
      #   with:
      #     version: 'latest'
      #     method: service-account
      #     k8s-url: https://10.0.0.90:6443
      #     k8s-secret: ${{ secrets.KUBECONFIG }}
      
      # - name: Checkout source code
      #   uses: actions/checkout@v3

      # - name: Deploy to the Kubernetes cluster
      #   uses: azure/k8s-deploy@v1
      #   with:
      #     namespace: default
      #     manifests: |
      #       kubernetes/deployment.yaml
      #     images: |
      #       ${{ steps.login-pf-aws-ecr.outputs.registry }}/${{ secrets.AWS_ECR_REPO }}:${{ env.NEW_VERSION }}