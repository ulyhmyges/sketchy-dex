package main

import (
	"api/database"
	"api/route"
)

func main() {
	pg := database.Connection()
	defer database.Disconnect(pg)
	route.RunServer()
}
