package users

import (
	"silance/modules/users/models"

	"gorm.io/gorm"
)

type Repository interface {
	FindAll() ([]models.User, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db}
}

// FindAll implements [Repository].
func (r *repository) FindAll() ([]models.User, error) {
	var users []models.User

	err := r.db.Find(&users).Error
	if err != nil {
		return []models.User{}, err
	}

	return users, nil
}
