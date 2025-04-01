This is a simple Flask app to expose an API at the default root path '/'.

Steps to clone the repository, build the docker image and push it to your own docker hub account
  1. Clone the repo.
     
     ```
     git clone https://github.com/pushkarlaulkar/devops-challenge.git
     ```
  2. Change into the **app** folder and run the below command to build the docker image.
     
     ```
     docker build -t simple-time-service:latest -f Dockerfile .
     ```
  3. Below output is the expected one which is shown when to image is being built

     ```
     root@ip-172-31-45-157:~/devops-challenge/app# docker build -t simple-time-service:latest -f Dockerfile .
     [+] Building 12.1s (9/9) FINISHED                                                                                                                                                          docker:default
     => [internal] load build definition from Dockerfile                                                                                                                                                 0.0s
     => => transferring dockerfile: 379B                                                                                                                                                                 0.0s
     => [internal] load metadata for docker.io/library/python:3.12-slim                                                                                                                                  0.6s
     => [internal] load .dockerignore                                                                                                                                                                    0.0s
     => => transferring context: 2B                                                                                                                                                                      0.0s
     => [1/4] FROM docker.io/library/python:3.12-slim@sha256:a866731a6b71c4a194a845d86e06568725e430ed21821d0c52e4efb385cf6c6f                                                                            5.2s
     => => resolve docker.io/library/python:3.12-slim@sha256:a866731a6b71c4a194a845d86e06568725e430ed21821d0c52e4efb385cf6c6f                                                                            0.0s
     => => sha256:a866731a6b71c4a194a845d86e06568725e430ed21821d0c52e4efb385cf6c6f 9.12kB / 9.12kB                                                                                                       0.0s
     => => sha256:5ada6d11077457411f44a0b126462d1334942b03945ac1686aed5e2c16931380 1.75kB / 1.75kB                                                                                                       0.0s
     => => sha256:73bcaeb9132b14bb09076fefd88ed9169c27c9bdc0a0111dd5348af5e98e3a3a 5.50kB / 5.50kB                                                                                                       0.0s
     => => sha256:6e909acdb790c5a1989d9cfc795fda5a246ad6664bb27b5c688e2b734b2c5fad 28.20MB / 28.20MB                                                                                                     1.8s
     => => sha256:0b564fcd72a23e125aa17f344431b8e2189a5b8f89e78953466669795e7f8089 3.51MB / 3.51MB                                                                                                       0.9s
     => => sha256:e4eb3ff0477a6c3c65761bad0d2aa2c1ce912cdcf883a37226f28e6e277126b6 13.65MB / 13.65MB                                                                                                     1.7s
     => => sha256:75c77ac11059535a2a5409b794c1bec09cac945ffe1dfd92215c68f2ed2d35d4 249B / 249B                                                                                                           1.2s
     => => extracting sha256:6e909acdb790c5a1989d9cfc795fda5a246ad6664bb27b5c688e2b734b2c5fad                                                                                                            1.8s
     => => extracting sha256:0b564fcd72a23e125aa17f344431b8e2189a5b8f89e78953466669795e7f8089                                                                                                            0.2s
     => => extracting sha256:e4eb3ff0477a6c3c65761bad0d2aa2c1ce912cdcf883a37226f28e6e277126b6                                                                                                            0.8s
     => => extracting sha256:75c77ac11059535a2a5409b794c1bec09cac945ffe1dfd92215c68f2ed2d35d4                                                                                                            0.0s
     => [internal] load build context                                                                                                                                                                    0.0s
     => => transferring context: 651B                                                                                                                                                                    0.0s
     => [2/4] WORKDIR /app                                                                                                                                                                               0.1s
     => [3/4] COPY server.py requirements.txt ./                                                                                                                                                         0.1s
     => [4/4] RUN pip3 install --no-cache-dir -r requirements.txt                                                                                                                                        5.7s
     => exporting to image                                                                                                                                                                               0.2s 
     => => exporting layers                                                                                                                                                                              0.2s 
     => => writing image sha256:4554e3ebf15a0889a6b221c56f3289891060d6048e485958795ae0da18b3064b                                                                                                         0.0s 
     => => naming to docker.io/library/simple-time-service:latest
     ```
  4. Run the command `docker images` to check the list of images. Below expected output

     ```
     root@ip-172-31-45-157:~/devops-challenge/app# docker images                                                                                                                                               
     REPOSITORY            TAG              IMAGE ID       CREATED         SIZE                                                                                                                                
     simple-time-service   latest           4554e3ebf15a   5 seconds ago   137MB
     ```
  5. Login to Docker hub by running below command.

     ```
     docker login
     ```
  6. You will be presented with below output

     ```
     root@ip-172-31-45-157:~/devops-challenge# docker login

     USING WEB-BASED LOGIN
      
     i Info → To sign in with credentials on the command line, use 'docker login -u <username>'
               
      
     Your one-time device confirmation code is: ABCD-EFGH
     Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate
      
     Waiting for authentication in the browser…
     ```
  7. Perform the authentication with your docker hub credentials and you will be ready to push images. Below is the expected output

     ```
     WARNING! Your credentials are stored unencrypted in '/root/.docker/config.json'.
     Configure a credential helper to remove this warning. See
     https://docs.docker.com/go/credential-store/

     Login Succeeded
     ```
  8. Tag the existing image so that you can push it your docker hub account and then run the push command as below

     ```
     root@ip-172-31-45-157:~/devops-challenge/app# docker tag simple-time-service:latest plaulkar/simple-time-service:latest 
     root@ip-172-31-45-157:~/devops-challenge/app# docker push plaulkar/simple-time-service:latest 
     The push refers to repository [docker.io/plaulkar/simple-time-service]
     4e1ba706109f: Pushed 
     f669342c6c2e: Pushed 
     e3c83921c44d: Pushed 
     9ae9750f0b5d: Mounted from library/python 
     a38884fb0360: Mounted from library/python 
     3629edeced43: Mounted from library/python 
     1287fbecdfcc: Mounted from library/python 
     latest: digest: sha256:0749d6a1440b58d19dd8edb44f9c18796c7b0693934ec146a1d511af6d274279 size: 1783
     ```
  9. Create a container of this docker image by running below command
      
     ```
     docker run -d --name simple-test-service -p 80:80 plaulkar/simple-time-service:latest
     ```

---------------------------

**Terraform**

  Below is the infrastructure deployed by terraform
  
    1. A VPC with 2 Public & 2 Private subnets.
    2. A NAT Gateway deployed in one of the public subnet, an EIP associated with the NAT Gateway.
    3. An ECS cluster, task definition & a service which deploys a task into a private subnet. A security group associated with the ECS task which only allows port 80 within VPC.
    4. An ALB deployed in the public subnets, a target group of type IP which corresponds to the task. A security group associated with the ALB to allow port 80 on all IP's.

  Instructions to deploy the infrastructure

    1. cd terraform
    2. terraform init
    3. terraform plan
    4. terraform apply

  Terraform will output the ALB DNS which can be put in the browser to access the application.
  
  Note :- The ALB DNS might take a couple of minutes to be accessible.
