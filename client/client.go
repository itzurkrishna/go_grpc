package main

import (
	"context"
	pb "calculator.com/m/proto/proto" // Import the protobuf package
	"log"

	"google.golang.org/grpc"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Failed to dial server: %v", err)
	}
	defer conn.Close()

	// Create a client for the Calculator service.
	client := pb.NewCalculatorClient(conn)

	// Prepare the request.
	req := &pb.AddRequest{
		Num1: 10,
		Num2: 20,
	}

	// Send the request to the server.
	res, err := client.Add(context.Background(), req)
	if err != nil {
		log.Fatalf("Failed to add numbers: %v", err)
	}

	// Display the result.
	log.Printf("Result of adding %d and %d: %d", req.Num1, req.Num2, res.Result)
}
