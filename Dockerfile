# Use a Golang base image with Go 1.20 or later for building
FROM golang:1.20 AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the protobuf files
COPY calculator.proto proto/

# Depending on the service, copy and build the appropriate source code
ARG SERVICE
COPY ${SERVICE}/ ./${SERVICE}/

# Set the working directory to the service directory
WORKDIR /app/${SERVICE}

# Build the service
RUN go build -o ${SERVICE}

# Set the base image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/${SERVICE}/${SERVICE} ./

# Command to run the service
CMD ["./client"]
