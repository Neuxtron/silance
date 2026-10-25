package messages

import "github.com/gin-gonic/gin"

func InitiateRoutes(router *gin.RouterGroup) {
	api := router.Group("/messages")

	server := NewServer()
	controller := NewController(server)

	api.GET("/:room", controller.WsHandler)
}
