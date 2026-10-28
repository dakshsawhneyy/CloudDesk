
# Stage 1: Install dependencies
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY src/ ./src/

# Stage 2: Production image
FROM node:22-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV GOOGLE_APPLICATION_CREDENTIALS=/run/credentials/gcp-wif.json

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder --chown=appuser:appgroup /app/src ./src

USER appuser

EXPOSE 3000

CMD ["node", "src/server.js"]