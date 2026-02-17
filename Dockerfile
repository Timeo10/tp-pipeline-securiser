# ---------- deps ----------
    FROM node:20-alpine AS deps
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci
    
    # ---------- build (si tu as du build, sinon ok quand même) ----------
    FROM node:20-alpine AS build
    WORKDIR /app
    COPY --from=deps /app/node_modules ./node_modules
    COPY . .
    # Si tu as une étape build (TS, etc), décommente:
    # RUN npm run build
    
    # ---------- production ----------
    FROM node:20-alpine AS prod
    WORKDIR /app
    ENV NODE_ENV=production
    
    # user non-root
    RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
    USER nodeuser
    
    # on copie seulement le nécessaire
    COPY --chown=nodeuser:nodegroup package*.json ./
    COPY --chown=nodeuser:nodegroup --from=deps /app/node_modules ./node_modules
    COPY --chown=nodeuser:nodegroup --from=build /app ./

    

    EXPOSE 3000
    CMD ["node", "src/index.js"]
    