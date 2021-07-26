#FROM 446567516155.dkr.ecr.ap-southeast-1.amazonaws.com/docker-image-common-alpine 
FROM debian:buster-backports
RUN apt update && apt install -y curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs
RUN apt update && apt install -t buster-backports -y libreoffice
RUN apt-get install -y ghostscript
RUN apt-get install -y graphicsmagick
RUN apt-get install -y make
RUN apt-get install -y build-essential libssl-dev
RUN apt-get install -y wget

RUN cd /tmp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz
RUN tar -zxvf cmake-3.21.0.tar.gz
RUN cd cmake-3.21.0 && ./bootstrap && make && make install

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

#RUN npm install
RUN npm ci --only=production

# Bundle app source
COPY . .

CMD ["node","main.js"]
