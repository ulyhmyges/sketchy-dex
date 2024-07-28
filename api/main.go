package main

import (
	"api/database"
	"api/route"
	"log"

	"github.com/joho/godotenv"
)

func main() {
	load(".env")
	pg := database.Connection()
	defer database.Disconnect(pg)
	route.RunServer()
}

func load(env_file string) {
	err := godotenv.Load(env_file)
	if err != nil {
		log.Println("======Unable to load .env file!=====")
	}
	log.Println("=====load .env file=====")
}
