package messages

import (
	"log"
	"net/http"
	"silance/helper"

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
	server *Server
}

func NewController(server *Server) *Controller {
	return &Controller{server}
}

func (c *Controller) WsHandler(ctx *gin.Context) {
	room := ctx.Param("room")

	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		log.Println("Failed to connect websocket: ", err)
		return
	}

	client := &Client{Conn: conn, Send: make(chan []byte, 256)}

	for {
		hub := c.server.GetRoom(room)
		client.Hub = hub

		select {
		case hub.register <- client:
			go client.ReadPump()
			go client.WritePump()
			return
		case <-hub.done:
		}
	}
}
