package models

import "github.com/google/uuid"

type UserDto struct {
	ID          uuid.UUID `json:"id"`
	Phone       string    `json:"phone"`
	Username    *string   `json:"username"`
	DisplayName string    `json:"display_name"`
	CreatedAt   string    `json:"created_at"`
}
