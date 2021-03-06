# Apply env variables and secrets
kubectl apply -f k8s/aws-secret.yaml
kubectl apply -f k8s/env-secret.yaml
kubectl apply -f k8s/env-configmap.yaml

# Deployments
kubectl apply -f udagram-api-feed/deploy/deployment.yaml
kubectl apply -f udagram-api-user/deploy/deployment.yaml
kubectl apply -f udagram-reverseproxy/deploy/deployment.yaml

# Service
kubectl apply -f udagram-api-feed/deploy/service.yaml
kubectl apply -f udagram-api-user/deploy/service.yaml
kubectl apply -f udagram-reverseproxy/deploy/service.yaml

# Expose public IPs
kubectl expose deployment reverseproxy --type=LoadBalancer --name=publicreverseproxy

# Set up Kubernetes Metrics Server (for autoscaler to fetch resource metrics)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Horizontal Pod Autoscaler
kubectl autoscale deployment udagram-api-feed --cpu-percent=50 --min=1 --max=2
kubectl autoscale deployment udagram-api-user --cpu-percent=50 --min=1 --max=2
