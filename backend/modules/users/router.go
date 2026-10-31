package users

import (
	"silance/database"
	"silance/middlewares"

	"github.com/gin-gonic/gin"
)

func InitiateRoutes(router *gin.RouterGroup) {
	api := router.Group("/users")

	repo := NewRepository(database.DBConnection)
	service := NewService(repo)
	controller := NewController(service)

	api.GET("", middlewares.AuthMiddleware(), controller.GetHomeUsers)
}
