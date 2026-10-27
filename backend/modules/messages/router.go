package messages

import (
	"silance/middlewares"

	"github.com/gin-gonic/gin"
)

func InitiateRoutes(router *gin.RouterGroup) {
	api := router.Group("/messages")

	hub := NewHub()
	go hub.Run()

	controller := NewController(hub)

	api.GET("", middlewares.AuthMiddleware(), controller.WsHandler)
}
