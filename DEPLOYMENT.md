# TR-808 Drum Machine - Deployment Guide

## Infrastructure Overview

This project deploys across your existing 3-tier Tailscale mesh network:

- **OSIRIS (Windows 11)**: `100.80.43.125` - Control plane and development
- **DEV-GPU (Ubuntu)**: `100.106.201.33` - Staging environment  
- **VPS (Hostinger)**: `100.96.28.69` - Production deployment

## Deployment Environments

### Local Development
```bash
# Start local development server
npm run dev

# Docker development
npm run docker:build
npm run docker:run
# App available at http://localhost:3000
```

### Staging (DEV-GPU)
```bash
# Automated staging deployment
npm run deploy:staging

# Manual deployment
./scripts/deploy/staging-deploy.sh

# Access staging
# http://100.106.201.33:3001
```

### Production (VPS)
```bash
# Automated production deployment (requires main branch)
npm run deploy:production

# Manual deployment
./scripts/deploy/production-deploy.sh

# Access production
# http://100.96.28.69 or your custom domain
```

## CI/CD Pipeline

### GitHub Actions Workflow

The pipeline automatically:
1. **Lint & Validate** - Code quality checks
2. **Build** - Create production assets
3. **Docker Build** - Create container image in GHCR
4. **Deploy Staging** - Auto-deploy to DEV-GPU on develop/main branches
5. **Deploy Production** - Manual trigger or `[deploy]` in commit message

### Triggers

- **Push to `develop`**: Deploys to staging
- **Push to `main`**: Deploys to staging, optional production
- **Manual trigger**: Full control over deployment targets
- **Commit with `[deploy]`**: Forces production deployment

## Container Registry

Images are stored in GitHub Container Registry:
```
ghcr.io/carlosirineuacosta/tr808-drum:latest
ghcr.io/carlosirineuacosta/tr808-drum:main-abc1234
```

## Required Secrets

### GitHub Repository Secrets
```bash
VPS_SSH_KEY          # SSH private key for production VPS
CLAUDE_API_KEY       # Optional: For AI pattern generation
GRAFANA_API_KEY      # Optional: For deployment notifications
```

### Environment Variables
Copy `.env.example` to `.env` and configure:
```bash
cp .env.example .env
# Edit .env with your specific configuration
```

## Health Checks

All deployments include health checks:
- **Endpoint**: `/health`
- **Interval**: 30 seconds
- **Timeout**: 10 seconds
- **Retries**: 3

## Zero-Downtime Deployment

Production deployments use blue-green strategy:
1. Start new container on temporary port
2. Health check new container
3. Switch traffic from old to new
4. Remove old container

## Monitoring Integration

### Grafana Cloud
- Deployment notifications sent to Grafana
- Container health metrics
- Application performance tracking

### Container Logs
```bash
# Staging logs
ssh cdc@100.106.201.33 "docker logs tr808-staging -f"

# Production logs  
ssh root@100.96.28.69 "docker logs tr808-prod -f"
```

## Rollback Procedures

### Staging Rollback
```bash
ssh cdc@100.106.201.33 << EOF
docker stop tr808-staging
docker run -d --name tr808-staging-rollback -p 3001:80 \
  ghcr.io/carlosirineuacosta/tr808-drum:previous-tag
EOF
```

### Production Rollback
```bash
ssh root@100.96.28.69 << EOF
docker stop tr808-prod
docker run -d --name tr808-prod -p 80:80 \
  ghcr.io/carlosirineuacosta/tr808-drum:previous-tag
EOF
```

## Security Considerations

### Network Security
- All hosts connected via Tailscale mesh VPN
- SSH key-based authentication only
- Container isolation with minimal attack surface

### Image Security
- Minimal Alpine Linux base image
- No unnecessary packages
- Security headers configured in nginx
- Content Security Policy enforced

### Secrets Management
- GitHub secrets for CI/CD
- 1Password CLI integration (existing setup)
- No secrets in container images or code

## Troubleshooting

### Common Issues

**Container won't start:**
```bash
docker logs <container-name>
docker inspect <container-name>
```

**Network connectivity:**
```bash
# Test Tailscale connectivity
tailscale ping 100.106.201.33
tailscale ping 100.96.28.69
```

**Health check failures:**
```bash
curl -f http://localhost/health
# Check nginx configuration
docker exec <container> nginx -t
```

**Build failures:**
```bash
# Check GitHub Actions logs
gh run list
gh run view <run-id>
```

### Support Commands

```bash
# Check container status
docker ps -a

# View container logs
docker logs <container-name> --tail 100

# Execute shell in container
docker exec -it <container-name> /bin/sh

# Test nginx configuration
docker exec <container-name> nginx -t

# Restart container
docker restart <container-name>
```

## Performance Optimization

### Nginx Configuration
- Gzip compression enabled
- Static asset caching (1 year)
- Connection keep-alive
- Worker process optimization

### Container Resources
```yaml
# Production resource limits (docker-compose)
deploy:
  resources:
    limits:
      memory: 256M
      cpus: '0.5'
    reservations:
      memory: 128M
      cpus: '0.25'
```

## Backup Strategy

### Application Data
- Static files stored in git repository
- Container images stored in GHCR with retention
- User patterns stored in browser localStorage (future: database)

### Configuration Backup
```bash
# Backup container configurations
docker inspect tr808-prod > backup/prod-config.json
docker inspect tr808-staging > backup/staging-config.json
```

## Monitoring URLs

- **Staging**: http://100.106.201.33:3001
- **Production**: http://100.96.28.69
- **Health Checks**: Add `/health` to any URL
- **Grafana**: Your existing Grafana Cloud instance