# Stage 1: Build the application
FROM node:18 AS build-stage

WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app's source code
COPY . .

# Run tests (optional step)
RUN npm test

# Build the app for production
RUN npm run build

# Stage 2: Create the production image
FROM nginx:alpine AS production-stage

# Copy the build files from the build stage
COPY --from=build-stage /app/build /usr/share/nginx/html

# Expose the port that nginx will listen on
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
