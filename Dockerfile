# Use the official node image as a base image
FROM node:18.16.0-bullseye

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json .npmrc yarn.lock /app

# Install dependencies
RUN yarn install

# Copy the rest of the application
COPY . .

# Build the app
RUN yarn run build

# Use a smaller image for production
FROM nginx:alpine

# Copy the built app to the Nginx server
COPY --from=0 /app/build /usr/share/nginx/html
COPY --from=0 /app/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
