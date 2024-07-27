package main

import (
	"api/database"
	"api/model"

	"github.com/gin-gonic/gin"
)

func main() {
	pg := database.Connect()
	defer database.Disconnect(pg)
	router := gin.Default()
	router.GET("/users", model.GetUsers)
	router.POST("/users", model.PostUsers)
	router.GET("/users/:id", model.GetUserById)
	router.Run("localhost:8001")
}
