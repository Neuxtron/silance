package auth

import (
	"silance/database"
	"silance/middlewares"

	"github.com/gin-gonic/gin"
)

func InitiateRoutes(router *gin.RouterGroup) {
	api := router.Group("/auth")

	repository := NewRepository(database.DBConnection)
	service := NewService(repository)
	controller := NewController(service)

	api.POST("/register", controller.Register)
	api.POST("/login", controller.Login)
	api.GET("/users", controller.GetAllUsers)
	api.GET("/profile", middlewares.AuthMiddleware(), controller.GetProfile)
}
