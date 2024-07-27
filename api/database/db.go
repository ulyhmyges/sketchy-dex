package database

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5"
)

func Connect() {
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABSE_URL"))
	if err != nil {
		fmt.Fprint(os.Stderr, "Unable to connect to database: %v\n", err)
	}
}
