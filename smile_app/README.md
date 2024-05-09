#  Instructions for building and running the container locally

### STEP 1 - Clone the Repo

### STEP 2 - Build the Docker Image:
Open a terminal, navigate to your application's root directory (where the Dockerfile is located), and run the following command to build the Docker image:

`docker build -t smile-app .`

### STEP 3 - Run the Docker Container:
After the image is built, you can run a Docker container based on that image using the following command:

`docker run -p 3000:3000 smile-app`

This command maps port 3000 of the Docker container to port 3000 on your host machine.
The application should now be running inside a Docker container. You can access it at http://localhost:3000 in your web browser or postman.
