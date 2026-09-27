FROM node:20.11.0-alpine
WORKDIR /workspace
COPY package.json ./
COPY src ./src
COPY scripts ./scripts
CMD ["node", "src/app.js"]
