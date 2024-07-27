package main

import (
	"api/database"
	"api/model"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load("../.env")
	if err != nil {
		log.Fatal("Unable to load .env file!")
	}
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		log.Fatalln("Empty DATABASE_URL variable")
	}
	pg := database.Connect(url)
	defer database.Disconnect(pg)
	router := gin.Default()
	router.GET("/users", model.GetUsers)
	router.POST("/users", model.PostUsers)
	router.GET("/users/:id", model.GetUserById)
	router.Run("localhost:8001")
}
