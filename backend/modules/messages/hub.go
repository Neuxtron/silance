package messages

type Message struct {
	sender *Client
	data   []byte
}

type Hub struct {
	name       string
	server     *Server
	clients    map[*Client]bool
	broadcast  chan Message
	register   chan *Client
	unregister chan *Client
	done       chan struct{}
}

func NewHub(room string, server *Server) *Hub {
	return &Hub{
		name:       room,
		server:     server,
		clients:    make(map[*Client]bool),
		broadcast:  make(chan Message),
		register:   make(chan *Client),
		unregister: make(chan *Client),
		done:       make(chan struct{}),
	}
}

func (h *Hub) Run() {
	for {
		select {
		case c := <-h.register:
			if len(h.clients) >= 2 {
				select {
				case c.Send <- []byte("Room is full"):
				default:
				}
				close(c.Send)
				continue
			}
			h.clients[c] = true

		case c := <-h.unregister:
			if _, ok := h.clients[c]; ok {
				delete(h.clients, c)
				close(c.Send)
			}

			if len(h.clients) == 0 {
				h.server.DeleteRoom(h.name)
				close(h.done)
				return
			}

		case m := <-h.broadcast:
			if _, ok := h.clients[m.sender]; !ok {
				continue
			}

			for c := range h.clients {
				if c == m.sender {
					continue
				}

				select {
				case c.Send <- m.data:
				default:
					delete(h.clients, c)
					close(c.Send)
				}
			}
		}
	}
}
