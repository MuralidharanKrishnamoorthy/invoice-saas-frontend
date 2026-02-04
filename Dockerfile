# Build stage
FROM node:18-alpine as build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built files
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration as a template for environment variable substitution
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Disable the problematic default IPv6 listener script in the Nginx image
RUN rm -f /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh


# Start nginx
CMD ["nginx", "-g", "daemon off;"]
