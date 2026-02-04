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
# The Nginx image automatically processes .template files in /etc/nginx/templates/
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
