package main

import (
	"api/model"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/users", model.GetUsers)
	router.Run("localhost:8001")
}
