package auth

import (
	"silance/helper"
	"silance/modules/auth/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Repository interface {
	CreateUser(*models.User) error
	UpdateUser(id uuid.UUID, user *models.User) error
	FindAll() ([]models.User, error)
	FindSingle(uuid.UUID) (*models.User, error)
	FindByPhone(phone string) (*models.User, error)
	FindByUsername(username string) (*models.User, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db}
}

// CreateUser implements [Repository].
func (r *repository) CreateUser(user *models.User) error {
	err := r.db.Create(user).Error
	return translateUniques(err)
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

// FindSingle implements [Repository].
func (r *repository) FindSingle(id uuid.UUID) (*models.User, error) {
	user := &models.User{}
	err := r.db.Where(&models.User{ID: id}).First(user).Error
	return user, err
}

// UpdateUser implements [Repository].
func (r *repository) UpdateUser(id uuid.UUID, user *models.User) error {
	err := r.db.Where(&models.User{ID: id}).Updates(user).Error
	return translateUniques(err)
}

// FindByPhone implements [Repository].
func (r *repository) FindByPhone(phone string) (*models.User, error) {
	user := &models.User{}
	err := r.db.Where(&models.User{Phone: phone}).First(user).Error
	return user, err
}

// FindByUsername implements [Repository].
func (r *repository) FindByUsername(username string) (*models.User, error) {
	user := &models.User{}
	err := r.db.Where(&models.User{Username: &username}).First(user).Error
	return user, err
}

func translateUniques(err error) error {
	// OPTIMIZE: use gorm.ErrDuplicatedKey and move to contorller
	if err != nil {
		err = helper.TranslateUniqueError(err, map[string]string{
			"idx_users_phone":    "Phone number is already registered",
			"idx_users_username": "This username is already used",
		})
		return err
	}
	return nil
}
