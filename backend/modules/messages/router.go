package messages

import "github.com/gin-gonic/gin"

func InitiateRoutes(router *gin.RouterGroup) {
	// TODO: register router, then test;;
	api := router.Group("/messages")

	server := NewServer()
	controller := NewController(server)

	api.GET("/ws/:room", controller.WsHandler)
}
