# Use Alpine Linux for a lightweight image
FROM alpine:3.19

# Set environment variables
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Install NGINX and required dependencies
RUN apk add --no-cache nginx openssl bash

# Copy configuration files
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Generate SSL certificates (self-signed for testing purposes)
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout /etc/nginx/ssl/nginx.key -x509 -days 365 -out /etc/nginx/ssl/nginx.crt -subj "/C=NL/L=Amsterdam/O=CODAM/CN=guzzy"

# Expose port 443
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]