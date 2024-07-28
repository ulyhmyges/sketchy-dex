package route

import "github.com/gin-gonic/gin"

var router = gin.Default()

func RunServer() {
	getRoutes()
	router.Run(":8080")
}

func getRoutes() {
	api := router.Group("/api")
	addUserRoutes(api)
}
