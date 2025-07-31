# TR-808 Drum Machine Docker Image
FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy application files
COPY dist/ /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Expose port 80
EXPOSE 80

# Labels for metadata
LABEL org.opencontainers.image.title="TR-808 AI Drum Machine"
LABEL org.opencontainers.image.description="Web-based TR-808 drum machine with AI pattern generation"
LABEL org.opencontainers.image.url="https://github.com/CarlosIrineuCosta/tr808-drum"
LABEL org.opencontainers.image.source="https://github.com/CarlosIrineuCosta/tr808-drum"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="$BUILD_DATE"
LABEL org.opencontainers.image.revision="$VCS_REF"

# Start nginx
CMD ["nginx", "-g", "daemon off;"]