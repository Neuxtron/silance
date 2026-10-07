package models

type UserDto struct {
	ID          string  `json:"id"`
	Phone       string  `json:"phone" binding:"required"`
	Username    *string `json:"username"`
	DisplayName string  `json:"display_name" binding:"required"`
	CreatedAt   string  `json:"created_at"`
}
