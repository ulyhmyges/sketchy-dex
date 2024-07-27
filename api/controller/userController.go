package controller

import (
	"api/model"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

var users = []model.User{
	{Id: 1, Username: "test", Password: "test", Address: "0xkroe453"},
	{Id: 2, Username: "username", Password: "password", Address: "address..."},
}

func GetUsers(context *gin.Context) {
	context.IndentedJSON(http.StatusOK, users)
}

func PostUsers(c *gin.Context) {
	var user model.User

	// Use Context.BindJSON to bind the request body to user.
	if err := c.BindJSON(&user); err != nil {
		return
	}
	users = append(users, user)

	// Add a 201 status code to the response,
	// along with JSON representing the album you added.
	c.IndentedJSON(http.StatusCreated, user)
}

func GetUserById(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err.Error())
	}

	for i, a := range users {
		if a.Id == id {
			log.Println(i)
			c.IndentedJSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "user not found"})
}
