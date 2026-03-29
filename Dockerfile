# ==========================================
# BUILD STAGE
# ==========================================
FROM golang:1.22-alpine AS build

WORKDIR /app

# Install git (dibutuhkan untuk go mod)
RUN apk add --no-cache git

# Copy go mod & sum dulu (cache dependency)
COPY go.mod go.sum ./
RUN go mod download

# Copy semua source code
COPY . .

# Build binary
RUN go build -o main ./cmd/server/main.go

# ==========================================
# RUNTIME STAGE
# ==========================================
FROM alpine:latest

WORKDIR /app

# Install CA cert (biar HTTPS jalan)
RUN apk add --no-cache ca-certificates

# Copy binary dari build stage
COPY --from=build /app/main .

# Expose port (sesuai server kamu)
EXPOSE 8080

# Run app
CMD ["./main"]