package auth

import (
	userModels "silance/modules/users/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Repository interface {
	CreateUser(*userModels.User) error
	UpdateUser(id uuid.UUID, user *userModels.User) error
	FindSingle(uuid.UUID) (*userModels.User, error)
	FindByPhone(phone string) (*userModels.User, error)
	FindByUsername(username string) (*userModels.User, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db}
}

// CreateUser implements [Repository].
func (r *repository) CreateUser(user *userModels.User) error {
	err := r.db.Create(user).Error
	return err
}

// FindAll implements [Repository].
func (r *repository) FindAll() ([]userModels.User, error) {
	var users []userModels.User

	err := r.db.Find(&users).Error
	if err != nil {
		return []userModels.User{}, err
	}

	return users, nil
}

// FindSingle implements [Repository].
func (r *repository) FindSingle(id uuid.UUID) (*userModels.User, error) {
	user := &userModels.User{}
	err := r.db.Where(&userModels.User{ID: id}).First(user).Error
	return user, err
}

// UpdateUser implements [Repository].
func (r *repository) UpdateUser(id uuid.UUID, user *userModels.User) error {
	err := r.db.Where(&userModels.User{ID: id}).Updates(user).Error
	return err
}

// FindByPhone implements [Repository].
func (r *repository) FindByPhone(phone string) (*userModels.User, error) {
	user := &userModels.User{}
	err := r.db.Where(&userModels.User{Phone: phone}).First(user).Error
	return user, err
}

// FindByUsername implements [Repository].
func (r *repository) FindByUsername(username string) (*userModels.User, error) {
	user := &userModels.User{}
	err := r.db.Where(&userModels.User{Username: &username}).First(user).Error
	return user, err
}
