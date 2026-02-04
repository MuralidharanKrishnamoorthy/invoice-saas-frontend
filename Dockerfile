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

# Copy nginx template (nginx image handles envsubst automatically here)
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
