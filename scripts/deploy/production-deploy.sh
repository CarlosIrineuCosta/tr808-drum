#!/bin/bash
# Deploy TR-808 to production VPS (100.96.28.69)

set -e

PROD_HOST="100.96.28.69"
PROD_USER="root"
IMAGE_NAME="ghcr.io/carlosirineuacosta/tr808-drum:latest"
CONTAINER_NAME="tr808-prod"
PORT="80"
HEALTH_PORT="3002"

echo "🚀 Deploying TR-808 to production environment..."

# Ensure we're on main branch for production
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Production deployment only allowed from main branch"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Working directory not clean. Commit changes first."
    exit 1
fi

echo "✅ Pre-flight checks passed"

# Zero-downtime deployment to production
echo "🔄 Deploying to production VPS (${PROD_HOST})..."

ssh ${PROD_USER}@${PROD_HOST} << EOF
    set -e
    
    # Login to GitHub Container Registry
    echo "🔐 Authenticating with GitHub Container Registry..."
    # Note: GITHUB_TOKEN should be set as environment variable
    
    echo "📥 Pulling latest image..."
    docker pull ${IMAGE_NAME}
    
    echo "🔄 Performing zero-downtime deployment..."
    
    # Start new container on health check port
    docker stop tr808-prod-new 2>/dev/null || true
    docker rm tr808-prod-new 2>/dev/null || true
    
    docker run -d \
        --name tr808-prod-new \
        --restart unless-stopped \
        -p ${HEALTH_PORT}:80 \
        --health-cmd="curl -f http://localhost/health || exit 1" \
        --health-interval=30s \
        --health-timeout=10s \
        --health-retries=3 \
        ${IMAGE_NAME}
    
    echo "⏳ Waiting for new container to be healthy..."
    sleep 15
    
    # Health check
    if curl -f http://localhost:${HEALTH_PORT}/health; then
        echo "✅ New container is healthy, switching traffic..."
        
        # Stop old container
        docker stop ${CONTAINER_NAME} 2>/dev/null || true
        docker rm ${CONTAINER_NAME} 2>/dev/null || true
        
        # Rename and restart new container on production port
        docker stop tr808-prod-new
        docker rm tr808-prod-new
        
        docker run -d \
            --name ${CONTAINER_NAME} \
            --restart unless-stopped \
            -p ${PORT}:80 \
            --health-cmd="curl -f http://localhost/health || exit 1" \
            --health-interval=30s \
            --health-timeout=10s \
            --health-retries=3 \
            ${IMAGE_NAME}
        
        echo "✅ Production deployment successful!"
        
        # Clean up old images
        docker image prune -f
        
    else
        echo "❌ Health check failed, rolling back..."
        docker logs tr808-prod-new
        docker stop tr808-prod-new
        docker rm tr808-prod-new
        exit 1
    fi
EOF

echo "🎉 Production deployment completed!"
echo "🌐 Production URL: http://${PROD_HOST}"

# Optional: Send notification to monitoring
echo "📊 Sending deployment notification..."
curl -X POST "https://api.grafana.com/api/annotations" \
    -H "Content-Type: application/json" \
    -d '{
        "text": "TR-808 Production Deployment",
        "tags": ["deployment", "production", "tr808"],
        "time": '$(date +%s000)'
    }' 2>/dev/null || echo "⚠️  Monitoring notification failed (optional)"