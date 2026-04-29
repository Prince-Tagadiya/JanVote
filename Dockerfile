FROM node:22-alpine AS builder

# Build frontend
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# Build backend
WORKDIR /app/server
COPY server/package*.json ./
RUN npm install --omit=dev
COPY server/ ./

# Final stage
FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app/client/dist ./client/dist
COPY --from=builder /app/server ./server
WORKDIR /app/server
EXPOSE 5000
CMD ["npm", "start"]
