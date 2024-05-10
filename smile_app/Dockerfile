# Stage 1: Build
# Use the official Node.js image as a base
FROM node:20 as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Production
# Use a smaller Node.js image
FROM node:20-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy built node modules and build directories from the previous stage
COPY --from=builder /usr/src/app .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "smile.js"]
