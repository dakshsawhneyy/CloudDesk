# Stage 1: Install dependencies
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY src/ ./src/
COPY gcp-wif.json /app/gcp-wif.json

# Stage 2: Production image
FROM node:22-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Create a non-root user
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

# Install only production dependencies
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Copy application code from builder
COPY --from=builder --chown=appuser:appgroup /app/src ./src

# Copy GCP Workload Identity Federation credentials
COPY --chown=appuser:appgroup /app/gcp-wif.json /app/gcp-wif.json

# Run as non-root user
USER appuser

EXPOSE 3000

CMD ["node", "src/server.js"]