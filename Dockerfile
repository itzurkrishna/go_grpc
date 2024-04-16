# Use a Golang base image with Go 1.19 or later for building
FROM golang:1.19 AS builder

# Set the working directory for the server
WORKDIR /app

# Copy the server source code and download dependencies
COPY server/go.mod server/go.sum ./
RUN go mod download

# Copy the client source code and download dependencies
COPY client/go.mod client/go.sum ./client/
RUN cd client && go mod download

# Copy the protobuf files and auto-generated code
COPY calculator.proto .
COPY auto_generated/calculator ./auto_generated/calculator/

# Copy the rest of the server source code
COPY server/. ./

# Build the server binary
RUN go build -o grpc-server .

# Set the working directory to /app in the final image
WORKDIR /app

# Use a minimal base image for the final Docker image
FROM alpine:latest

# Copy the server binary from the builder stage
COPY --from=builder /app/grpc-server ./server/

# Expose any ports needed by the server
EXPOSE 50051

# Command to run the server
CMD ["./server/grpc-server"]
