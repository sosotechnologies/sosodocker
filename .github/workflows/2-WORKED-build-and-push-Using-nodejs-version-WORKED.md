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

      - name: Extract version from package.json
        id: get_version
        run: |
          VERSION=$(jq -r '.version' package.json)
          echo "VERSION=$VERSION" >> $GITHUB_ENV

      - name: Build and push the tagged docker image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-pf-aws-ecr.outputs.registry }}
          ECR_REPOSITORY: ${{ secrets.AWS_ECR_REPO }}
          IMAGE_TAG: ${{ env.VERSION }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG