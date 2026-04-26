# ---- Build Stage ----
FROM node:20 AS builder

WORKDIR /app

# Copy dependency files first (for caching)
COPY package*.json ./


# Install all dependencies
RUN npm ci

# Copy source code
COPY . .

RUN npm run build

# ---- Production Stage ----
FROM node:20-alpine

WORKDIR /app

#Update OS packages
RUN apk update && apk upgrade

# Copy only necessary files from builder
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

EXPOSE 3000


# Run the app
CMD ["node", "dist/index.js"]
