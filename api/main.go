package main

import (
	"api/model"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/users", model.GetUsers)
	router.POST("/users", model.PostUsers)
	router.GET("/users/:id", model.GetUserById)
	router.Run("localhost:8001")
}
