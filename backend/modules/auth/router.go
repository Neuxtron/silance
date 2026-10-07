package auth

import (
	"silance/database"

	"github.com/gin-gonic/gin"
)

func InitiateRoutes(router *gin.RouterGroup) {
	api := router.Group("/auth")

	repository := NewRepository(database.DBConnection)
	service := NewService(repository)
	controller := NewController(service)

	api.POST("/register", controller.CreateUser)
	api.GET("/users", controller.GetAllUsers)
}
