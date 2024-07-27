package route

import (
	"api/controller"

	"github.com/gin-gonic/gin"
)

func addUserRoutes(rg *gin.RouterGroup) {
	users := rg.Group("/users")

	users.GET("/", controller.GetUsers)
	users.POST("/", controller.PostUsers)
	users.GET("/:id", controller.GetUserById)
}
