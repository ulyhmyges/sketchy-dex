package database

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
)

func Connect() *pgx.Conn {
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		fmt.Fprintf(os.Stderr, "===Unable to connect to database: %v\n===", err)
		log.Fatal()
	}
	return conn
}

func Disconnect(conn *pgx.Conn) {
	err := conn.Close(context.Background())
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to disconnect from database: %v\n", err)
		return
	}
	log.Println("Disconnect from daatabase")
}
