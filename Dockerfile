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

# Expose port (Railway will override this with the actual port)
EXPOSE 80

# Health check using the dynamic port
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:${PORT}/health || exit 1

# Start nginx (Nginx docker image automatically processes templates in /etc/nginx/templates/)
CMD ["nginx", "-g", "daemon off;"]



