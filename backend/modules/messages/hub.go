package messages

import (
	"encoding/json"
	"log"
	"silance/modules/messages/models"
	"strings"

	"github.com/google/uuid"
)

type Message struct {
	sender *Client
	data   models.MessageDto
}

type Hub struct {
	clients    map[uuid.UUID]*Client
	broadcast  chan Message
	register   chan *Client
	unregister chan *Client
}

func NewHub() *Hub {
	return &Hub{
		clients:    make(map[uuid.UUID]*Client),
		broadcast:  make(chan Message),
		register:   make(chan *Client),
		unregister: make(chan *Client),
	}
}

func (h *Hub) Run() {
	for {
		select {
		case c := <-h.register:
			h.clients[c.UserId] = c

		case c := <-h.unregister:
			if _, ok := h.clients[c.UserId]; ok {
				delete(h.clients, c.UserId)
				close(c.Send)
			}

		case msg := <-h.broadcast:
			ids, err := parseRoomID(msg.data.RoomID)
			if err != nil {
				continue
			}

			for _, id := range ids {
				if id == msg.sender.UserId {
					continue
				}

				c, ok := h.clients[id]
				if !ok {
					// Recipient is offline
					continue
				}
				bMsg, err := json.Marshal(msg.data)
				if err != nil {
					log.Printf("Failed to parse message: %s", err)
					continue
				}

				select {
				case c.Send <- bMsg:
				default:
					delete(h.clients, id)
					close(c.Send)
				}
			}
		}
	}
}

func parseRoomID(roomID string) ([]uuid.UUID, error) {
	uids := []uuid.UUID{}
	ids := strings.Split(roomID, "_")

	for _, id := range ids {
		uid, err := uuid.Parse(id)
		if err != nil {
			log.Printf("Failed to parse room id: %s", err)
			return []uuid.UUID{}, err
		}
		uids = append(uids, uid)
	}

	return uids, nil
}
