# Instructions for running the API locally

### STEP 1 - Install Node.js: Ensure you have Node.js installed on your laptop. 
You can download and install it from the official Node.js website: https://nodejs.org/

Verify that Node.js and npm are installed by running the following commands in your terminal or command prompt:
`node -v`
`npm -v`

### STEP 2 - Clone the Repo

### STEP 3 - Navigate into smile-app Directory and Initialize Node.js Project: 

Then, initialize a new Node.js project by running the following command:

`npm init -y`

### STEP 4 - Navigate to Your Project Directory:
Open your terminal or command prompt.
Use the cd command to navigate to the directory where your Express.js application files are located. For example:

cd /smile/smile_app

Install Dependencies:

run: 
`npm install`

This command will install Express.js as the dependency listed in the package.json file, including Express.js.


### STEP 5 - Run the Application:
Once the dependencies are installed, you can run your Express.js application by executing the following command in your terminal or command prompt:

`node smile.js`

### STEP 5 - Access the Application:
After running the command, you should see a message indicating that the application is listening on port 3000.
You can then access the application by opening a web browser and navigating to http://localhost:3000, or by sending a GET request to http://localhost:3000 using tools like cURL or Postman.


#  Instructions for building and running the container locally

### STEP 1 - Clone the Repo

### STEP 2 - Build the Docker Image:
Open a terminal, navigate to your application's root directory (where the Dockerfile is located), and run the following command to build the Docker image:

`docker build -t smile-app .`

### STEP 3 - Run the Docker Container:
After the image is built, you can run a Docker container based on that image using the following command in detached:

`docker run -d -p 3000:3000 smile-app`

This command maps port 3000 of the Docker container to port 3000 on your host machine.
The application should now be running inside a Docker container. You can then access the application by opening a web browser and navigating to http://localhost:3000, or by sending a GET request to http://localhost:3000 using tools like cURL or Postman.
