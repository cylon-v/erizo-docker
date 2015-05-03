# erizo-docker
This Dockerfile simplifies building Licode [ging/licode](https://github.com/ging/licode) components for custom Multipoint Control Unit (MCU) application.

### Base Docker Image
* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)

## Usage
1. Clone the repo: `git clone https://github.com/cylon-v/erizo-docker`
2. Create your own nodejs-app based on Erizo in app directory.  app/app.js contains dummy example of the application. You should use app.js as entrypint of your application because it's used as entrypoint of the container. Also you can use another files that you located in app directory - all these files will be added to container.
3. Build image `docker build -t erizo .`
4. Run container `docker run -it --name my-mcu -d erizo`
