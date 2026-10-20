package messages

import "sync"

type Server struct {
	mu    sync.Mutex
	rooms map[string]*Hub
}

func NewServer() *Server {
	return &Server{rooms: map[string]*Hub{}}
}

func (s *Server) GetRoom(room string) *Hub {
	s.mu.Lock()
	defer s.mu.Unlock()

	if hub, ok := s.rooms[room]; ok {
		return hub
	}

	hub := NewHub(room, s)
	go hub.Run()
	s.rooms[room] = hub
	return hub
}

func (s *Server) DeleteRoom(room string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	delete(s.rooms, room)
}
