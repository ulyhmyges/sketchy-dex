package database

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
)

func Connect(url string) *pgx.Conn {
	conn, err := pgx.Connect(context.Background(), url)
	log.Println("URL= ", url)
	if err != nil {
		fmt.Fprintf(os.Stderr, "===Unable to connect to database: %v\n===\n", err)
		log.Fatal()
	}
	fmt.Println("======Successfully connected to database!=====")
	return conn
}

func Disconnect(conn *pgx.Conn) {
	err := conn.Close(context.Background())
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to disconnect from database: %v\n", err)
		return
	}
	log.Println("Disconnect from database")
}

func Connection() *pgx.Conn {
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		log.Fatalln("Empty DATABASE_URL variable")
	}
	return Connect(url)
}
