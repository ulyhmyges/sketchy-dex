package main

import (
	"api/database"
	"api/route"
)

func main() {
	pg := database.Connection("../.env")
	defer database.Disconnect(pg)
	route.RunServer()
}
