ARG nodeVersion=18
FROM node:${nodeVersion}-alpine
WORKDIR /app

COPY . .

RUN npm install
RUN npm run build

ARG PORT_ARG=3000
RUN echo $PORT_ARG
ENV PORT=$PORT_ARG
EXPOSE $PORT_ARG

CMD ["npm", "run", "publish"]