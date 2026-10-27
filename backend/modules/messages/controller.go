package messages

import (
	"log"
	"net/http"
	"silance/helper"
	"silance/middlewares"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		if !helper.IsProd {
			return true
		}
		return false
	},
}

type Controller struct {
	hub *Hub
}

func NewController(hub *Hub) *Controller {
	return &Controller{hub}
}

func (c *Controller) WsHandler(ctx *gin.Context) {
	userId, _ := middlewares.CurrentUser(ctx)

	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		log.Println("Failed to connect websocket: ", err)
		return
	}

	client := &Client{
		UserId: userId,
		Hub:    c.hub,
		Conn:   conn,
		Send:   make(chan []byte, 256),
	}

	c.hub.register <- client
	go client.ReadPump()
	go client.WritePump()
}
