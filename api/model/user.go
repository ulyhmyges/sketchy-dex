package model

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type User struct {
	Id       int    `json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
	Address  string `json:"address"`
}

var users = []User{
	{Id: 1, Username: "test", Password: "test", Address: "0xkroe453"},
	{Id: 2, Username: "username", Password: "password", Address: "address..."},
}

func GetUsers(context *gin.Context) {
	context.IndentedJSON(http.StatusOK, users)
}
