package models

type MessageDto struct {
	ID       string `json:"id"`
	SenderID string `json:"sender_id"`
	RoomID   string `json:"room_id"`
	Content  string `json:"content"`
}
