package models

type RegisterDto struct {
	Phone       string  `json:"phone" binding:"required"`
	Username    *string `json:"username"`
	Password    string  `json:"password" binding:"required"`
	DisplayName string  `json:"display_name" binding:"required"`
}
