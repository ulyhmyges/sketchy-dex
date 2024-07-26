package main

import "github.com/gin-gonic/gin"

func main() {
	router := gin.Default()
	router.GET("/users", getUsers)
	router.Run("localhost:8001")
}
