FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:20-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
USER nodeuser

COPY --chown=nodeuser:nodegroup --from=deps /app/node_modules ./node_modules
COPY --chown=nodeuser:nodegroup . .

EXPOSE 3000
CMD ["node", "./bin/www"]
