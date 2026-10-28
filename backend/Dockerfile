
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
    adduser -S appuser -G appgroup && \
    mkdir -p /run/credentials && \
    chown -R appuser:appgroup /run/credentials /app

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder --chown=appuser:appgroup /app/src ./src

COPY --chown=appuser:appgroup docker-entrypoint.sh ./docker-entrypoint.sh
RUN sed -i 's/\r$//' ./docker-entrypoint.sh \
    && chmod 755 ./docker-entrypoint.sh

USER appuser

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
