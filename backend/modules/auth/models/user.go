package models

import (
	"strings"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type User struct {
	ID          uuid.UUID `json:"id" gorm:"type:uuid;primaryKey"`
	Phone       string    `json:"phone" gorm:"uniqueIndex:idx_users_phone;notNull"`
	Username    *string   `json:"username" gorm:"uniqueIndex:idx_users_username"`
	DisplayName string    `json:"display_name" gorm:"notNull"`

	CreatedAt time.Time       `json:"created_at" gorm:"notNull"`
	UpdatedAt time.Time       `json:"updated_at" gorm:"notNull"`
	DeletedAt *gorm.DeletedAt `json:"deleted_at"`
}

func (u *User) ToResponseDto() *UserDto {
	return &UserDto{
		ID:          u.ID.String(),
		Phone:       u.Phone,
		Username:    u.Username,
		DisplayName: u.DisplayName,
		CreatedAt:   u.CreatedAt.String(),
	}
}

func (u *User) BeforeSave(db *gorm.DB) error {
	if u.Username != nil && strings.TrimSpace(*u.Username) == "" {
		u.Username = nil
	}
	return nil
}
