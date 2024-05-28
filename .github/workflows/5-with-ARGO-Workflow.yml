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

      - name: Build and push image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-pf-aws-ecr.outputs.registry }}
          ECR_REPOSITORY: ${{ secrets.AWS_ECR_REPO }}
          IMAGE_TAG: ${{ env.NEW_VERSION }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Install Argo CLI
        run: |
          curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.3.8/argo-linux-amd64.gz
          gunzip argo-linux-amd64.gz
          chmod +x argo-linux-amd64
          sudo mv ./argo-linux-amd64 /usr/local/bin/argo

      - name: Configure kubectl
        run: |
          echo "${{ secrets.KUBECONFIG }}" | base64 --decode > $HOME/.kube/config

      - name: Add Argo Server Certificate to Trusted Certificates
        run: |
          sudo mkdir -p /usr/local/share/ca-certificates/extra
          echo "${{ secrets.ARGO_SERVER_CERT }}" | base64 --decode > argo-server.crt
          sudo cp argo-server.crt /usr/local/share/ca-certificates/extra/argo-server.crt
          sudo update-ca-certificates

      - name: Create Workflow YAML
        run: |
          cat <<EOF > nodejs-ecr-workflow.yaml
          apiVersion: argoproj.io/v1alpha1
          kind: Workflow
          metadata:
            name: nodejs-ecr
            annotations:
              workflows.argoproj.io/description: |
                Pulling image from Aws-Ecr
          spec:
            serviceAccountName: argo  # Ensure this matches the service account configured above
            entrypoint: main
            imagePullSecrets:
            - name: ecr-registry-secret-argo
            templates:
            - name: main
              container:
                image: ${{ steps.login-pf-aws-ecr.outputs.registry }}/${{ secrets.AWS_ECR_REPO }}:${{ env.NEW_VERSION }}
                command: ["/bin/sh"]
                args: ["-c", "echo Hello, Argo!"]
                ports:
                  - containerPort: 80
          EOF

      - name: Submit Workflow to Argo
        env:
          ARGO_SERVER: ${{ secrets.ARGO_SERVER }}
          ARGO_TOKEN: ${{ secrets.ARGO_TOKEN }}
        run: |
          argo submit --server $ARGO_SERVER --token $ARGO_TOKEN --insecure nodejs-ecr-workflow.yaml
