#!/bin/bash
# Deploy TR-808 to DEV-GPU staging environment (100.106.201.33)

set -e

STAGING_HOST="100.106.201.33"
STAGING_USER="cdc"
IMAGE_NAME="ghcr.io/carlosirineuacosta/tr808-drum:latest"
CONTAINER_NAME="tr808-staging"
PORT="3001"

echo "🚀 Deploying TR-808 to staging environment..."

# Build application locally
echo "📦 Building application..."
mkdir -p dist
cp tr808-mvp.html dist/index.html

# Build Docker image
echo "🐳 Building Docker image..."
docker build -t tr808-staging:local .

# Deploy to staging server via SSH
echo "🔄 Deploying to DEV-GPU (${STAGING_HOST})..."

ssh ${STAGING_USER}@${STAGING_HOST} << EOF
    set -e
    
    echo "Stopping existing container..."
    docker stop ${CONTAINER_NAME} 2>/dev/null || true
    docker rm ${CONTAINER_NAME} 2>/dev/null || true
    
    echo "Cleaning up old images..."
    docker image prune -f
    
    echo "Running new container..."
    docker run -d \
        --name ${CONTAINER_NAME} \
        --restart unless-stopped \
        -p ${PORT}:80 \
        --health-cmd="curl -f http://localhost/health || exit 1" \
        --health-interval=30s \
        --health-timeout=10s \
        --health-retries=3 \
        tr808-staging:local
    
    echo "Waiting for container to be healthy..."
    sleep 10
    
    # Health check
    if curl -f http://localhost:${PORT}/health; then
        echo "✅ Staging deployment successful!"
        echo "🌐 Access at: http://${STAGING_HOST}:${PORT}"
    else
        echo "❌ Health check failed"
        docker logs ${CONTAINER_NAME}
        exit 1
    fi
EOF

echo "🎉 Staging deployment completed!"
echo "🌐 Staging URL: http://${STAGING_HOST}:${PORT}"