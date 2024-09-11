# Utiliser une image Node.js officielle
FROM ubuntu

RUN apt-get update

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:tomtomtom/yt-dlp
RUN apt-get update

RUN apt-get install -y yt-dlp

ENV NODE_VERSION=20.17.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN apt-get upgrade -y

# Créer un dossier pour l'application
WORKDIR /usr/src/app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances Node.js
RUN npm install

# Copier le reste des fichiers de l'application
COPY . .

# Exposer le port du serveur Node.js
EXPOSE 7566

# Commande pour démarrer l'application
CMD ["npm", "start"]
