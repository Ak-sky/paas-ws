# Simple Dockerfile for AgroScan AI website
FROM nginx:alpine

# Copy the website files to the nginx default serving directory
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY scripts.js /usr/share/nginx/html/

# Simple nginx configuration with correct paths
RUN echo 'server { \
    listen 80 default_server; \
    listen [::]:80 default_server; \
    root /usr/share/nginx/html; \
    index index.html; \
    server_name _; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]