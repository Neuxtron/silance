package users

import (
	"silance/modules/users/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Repository interface {
	FindHomeData(id uuid.UUID) ([]models.User, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db}
}

// FindHomeData implements [Repository].
func (r *repository) FindHomeData(id uuid.UUID) ([]models.User, error) {
	var users []models.User

	err := r.db.Not(models.User{ID: id}).Find(&users).Error
	if err != nil {
		return []models.User{}, err
	}

	return users, nil
}
