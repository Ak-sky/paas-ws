# Multi-stage build for a more optimized AgroScan AI website container

# Stage 1: Build and optimize assets
FROM node:18-alpine AS build

WORKDIR /app

# Create website directory structure
RUN mkdir -p public/css public/js

# Copy website files
COPY index.html public/
COPY styles.css public/css/
COPY scripts.js public/js/

# Install tools for optimization
RUN npm install -g html-minifier csso-cli terser

# Optimize CSS
RUN csso public/css/styles.css -o public/css/styles.min.css

# Optimize JavaScript
RUN terser public/js/scripts.js -o public/js/scripts.min.js

# Optimize HTML and update references to minified files
RUN sed -i 's/styles.css/css\/styles.min.css/g' public/index.html && \
    sed -i 's/scripts.js/js\/scripts.min.js/g' public/index.html && \
    html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype --minify-css true --minify-js true --input-dir public --output-dir public --file-ext html

# Stage 2: Create the production image
FROM nginx:alpine

# Copy the optimized website from the build stage
COPY --from=build /app/public /usr/share/nginx/html

# Create a custom nginx configuration with best practices
RUN echo 'server { \
    listen 80 default_server; \
    listen [::]:80 default_server; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    # Enable compression \
    gzip on; \
    gzip_vary on; \
    gzip_min_length 10240; \
    gzip_proxied expired no-cache no-store private auth; \
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml; \
    gzip_disable "MSIE [1-6]\\."; \
    \
    # Security headers \
    add_header X-Frame-Options "SAMEORIGIN"; \
    add_header X-XSS-Protection "1; mode=block"; \
    add_header X-Content-Type-Options "nosniff"; \
    add_header Referrer-Policy "strict-origin-when-cross-origin"; \
    add_header Content-Security-Policy "default-src \"self\"; img-src \"self\" https://via.placeholder.com; style-src \"self\" \"unsafe-inline\"; script-src \"self\" \"unsafe-inline\""; \
    \
    # Cache control \
    location ~* \\.(jpg|jpeg|png|gif|ico|css|js)$ { \
        expires 30d; \
        add_header Cache-Control "public, no-transform"; \
    } \
    \
    # Redirect server error pages to the static pages \
    error_page 404 /404.html; \
    error_page 500 502 503 504 /50x.html; \
    location = /50x.html { \
        root /usr/share/nginx/html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Create a health check script
RUN echo '#!/bin/sh \
curl -f http://localhost:80 || exit 1' > /usr/local/bin/docker-health-check.sh && \
    chmod +x /usr/local/bin/docker-health-check.sh

# Create default error pages
RUN echo '<html><head><title>404 Not Found</title></head><body><h1>404 Not Found</h1><p>The page you requested was not found.</p><p><a href="/">Return to Home</a></p></body></html>' > /usr/share/nginx/html/404.html && \
    echo '<html><head><title>Server Error</title></head><body><h1>Server Error</h1><p>The server encountered an error processing your request.</p><p><a href="/">Return to Home</a></p></body></html>' > /usr/share/nginx/html/50x.html

# Create logs directory and configure log rotation
RUN mkdir -p /var/log/nginx && \
    echo '#!/bin/sh \
if [ -f /var/log/nginx/access.log ]; then \
    mv /var/log/nginx/access.log /var/log/nginx/access.log.old \
fi \
if [ -f /var/log/nginx/error.log ]; then \
    mv /var/log/nginx/error.log /var/log/nginx/error.log.old \
fi \
kill -USR1 $(cat /var/run/nginx.pid)' > /etc/periodic/daily/nginx-log-rotate && \
    chmod +x /etc/periodic/daily/nginx-log-rotate

# Port configuration
EXPOSE 80

# Set working directory
WORKDIR /usr/share/nginx/html

# Define healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD /usr/local/bin/docker-health-check.sh

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]