# AgroScan AI - Website Deployment

This repository contains the website for AgroScan AI, a precision agriculture drone company. The website is built with HTML, CSS, and JavaScript, and packaged for deployment using Docker.

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── index.html
├── styles.css
└── scripts.js
```

## Deployment Instructions

### Prerequisites

- Docker and Docker Compose installed on your server
- Basic knowledge of command line operations

### Option 1: Using Docker Compose (Recommended)

1. Copy all files to your server
2. Navigate to the directory containing the files
3. Run the following command:

```bash
docker-compose up -d
```

This will build the Docker image and start the container in detached mode. The website will be accessible on port 80.

### Option 2: Using Docker Directly

1. Copy all files to your server
2. Navigate to the directory containing the files
3. Build the Docker image:

```bash
docker build -t agroscan-website .
```

4. Run the Docker container:

```bash
docker run -d -p 80:80 --name agroscan-website agroscan-website
```

## Updating the Website

To update the website content:

1. Modify the HTML, CSS, or JavaScript files as needed
2. Rebuild and restart the container:

```bash
# If using Docker Compose
docker-compose down
docker-compose up -d --build

# If using Docker directly
docker stop agroscan-website
docker rm agroscan-website
docker build -t agroscan-website .
docker run -d -p 80:80 --name agroscan-website agroscan-website
```

## Monitoring and Logs

To view the logs of the running container:

```bash
# If using Docker Compose
docker-compose logs -f

# If using Docker directly
docker logs -f agroscan-website
```

## Health Check

The Docker Compose configuration includes a health check that verifies the website is responding properly. You can check the status with:

```bash
docker ps
```

Look for the `(healthy)` status next to the container name.

## Customization

- To change the port the website is served on, modify the `ports` section in the `docker-compose.yml` file
- To customize the NGINX configuration, you can add an nginx.conf file and update the Dockerfile to include it

## Troubleshooting

If you encounter issues:

1. Check the container logs for errors
2. Verify that port 80 is not already in use on your server
3. Ensure your firewall allows traffic on the specified port

## Security Considerations

This basic setup is suitable for a development or staging environment. For production:

1. Consider adding HTTPS using Let's Encrypt
2. Implement proper security headers
3. Set up a reverse proxy like NGINX or Traefik
4. Implement rate limiting

## Contact

For any questions or support, please contact the development team at dev@agroscanai.com.