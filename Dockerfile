# Simple Dockerfile for CocoBot Technologies website
FROM nginx:alpine

# Copy the website files to the nginx default serving directory
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY scripts.js /usr/share/nginx/html/

# Create a logo.svg file from the embedded SVG in index.html
RUN echo '<svg width="800" height="800" viewBox="0 0 800 800" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M512 262C512 234.4 489.6 212 462 212H337C309.4 212 287 234.4 287 262V312H512V262Z" fill="#1E6834"/><path d="M405 505C437.6 505 464 478.6 464 446C464 413.4 437.6 387 405 387C372.4 387 346 413.4 346 446C346 478.6 372.4 505 405 505Z" fill="#4CAF50"/><path d="M405 455C413.3 455 420 448.3 420 440C420 431.7 413.3 425 405 425C396.7 425 390 431.7 390 440C390 448.3 396.7 455 405 455Z" fill="#1E6834"/><path d="M405 525C448.1 525 483 490.1 483 447C483 403.9 448.1 369 405 369C361.9 369 327 403.9 327 447C327 490.1 361.9 525 405 525Z" fill="#1E6834"/><path d="M405 505C437.6 505 464 478.6 464 446C464 413.4 437.6 387 405 387C372.4 387 346 413.4 346 446C346 478.6 372.4 505 405 505Z" fill="#4CAF50"/><path d="M610 238H567C567 225.3 556.7 215 544 215C531.3 215 521 225.3 521 238H478C465.3 238 455 248.3 455 261V304C455 316.7 465.3 327 478 327H610C622.7 327 633 316.7 633 304V261C633 248.3 622.7 238 610 238Z" fill="#1E6834"/><path d="M321 238H278C278 225.3 267.7 215 255 215C242.3 215 232 225.3 232 238H189C176.3 238 166 248.3 166 261V304C166 316.7 176.3 327 189 327H321C333.7 327 344 316.7 344 304V261C344 248.3 333.7 238 321 238Z" fill="#1E6834"/><path d="M596 261H596C596 261 596 261 596 261L544 261C544 261 544 261 544 261V261H596Z" fill="#4CAF50"/><path d="M255 261H255C255 261 255 261 255 261L203 261C203 261 203 261 203 261V261H255Z" fill="#4CAF50"/><path d="M413 316V369C413 372.9 409.9 376 406 376C402.1 376 399 372.9 399 369V316H413Z" fill="#1E6834"/><path d="M287 312H512V312C512 312 485 365 399.5 365C314 365 287 312 287 312V312Z" fill="#1E6834"/></svg>' > /usr/share/nginx/html/logo.svg

# Create a favicon from the logo colors
RUN echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><rect width="16" height="16" fill="#1E6834"/><circle cx="8" cy="8" r="5" fill="#4CAF50"/><circle cx="8" cy="8" r="3" fill="#1E6834"/></svg>' > /usr/share/nginx/html/favicon.svg

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
    # Enable compression \
    gzip on; \
    gzip_vary on; \
    gzip_min_length 1000; \
    gzip_proxied expired no-cache no-store private auth; \
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml; \
    # Security headers \
    add_header X-Frame-Options "SAMEORIGIN"; \
    add_header X-XSS-Protection "1; mode=block"; \
    add_header X-Content-Type-Options "nosniff"; \
}' > /etc/nginx/conf.d/default.conf

# Create a simple HTML page for errors
RUN echo '<!DOCTYPE html><html><head><title>Error</title><style>body{font-family:sans-serif;text-align:center;padding:50px;background:#f5f5f5}h1{color:#1E6834}a{color:#4CAF50}</style></head><body><h1>Oops!</h1><p>Something went wrong. <a href="/">Return to Home</a></p></body></html>' > /usr/share/nginx/html/error.html

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]