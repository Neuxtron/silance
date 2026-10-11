package auth

import (
	"log"
	"silance/helper"
	"silance/modules/auth/models"
	userModels "silance/modules/users/models"

	"github.com/google/uuid"
)

type Service interface {
	CreateUser(*models.RegisterDto) (*userModels.UserDto, error)
	UpdateUser(id uuid.UUID, input *userModels.UserDto) error
	FindSingle(uuid.UUID) (*userModels.UserDto, error)
	Login(input models.LoginDto, password string) (bool, *userModels.UserDto)
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo}
}

// CreateUser implements [Service].
func (s *service) CreateUser(input *models.RegisterDto) (*userModels.UserDto, error) {
	id, err := uuid.NewV7()
	if err != nil {
		log.Printf("Failed to generate UUID: %s\n", err)
		return &userModels.UserDto{}, err
	}

	user := &userModels.User{
		ID:          id,
		Phone:       input.Phone,
		Username:    input.Username,
		Password:    input.Password,
		DisplayName: input.DisplayName,
	}

	if err := s.repo.CreateUser(user); err != nil {
		log.Printf("Failed to create user: %s\n", err)
		return &userModels.UserDto{}, err
	}

	return user.ToResponseDto(), err
}

// FindSingle implements [Service].
func (s *service) FindSingle(id uuid.UUID) (*userModels.UserDto, error) {
	user, err := s.repo.FindSingle(id)
	return user.ToResponseDto(), err
}

// UpdateUser implements [Service].
func (s *service) UpdateUser(id uuid.UUID, input *userModels.UserDto) error {
	user := &userModels.User{
		Phone:       input.Phone,
		Username:    input.Username,
		DisplayName: input.DisplayName,
	}
	err := s.repo.UpdateUser(id, user)

	*input = *user.ToResponseDto()
	return err
}

func (s *service) Login(input models.LoginDto, password string) (bool, *userModels.UserDto) {
	var user userModels.User
	exists := false

	if input.Phone != nil {
		model, err := s.repo.FindByPhone(*input.Phone)
		if err == nil {
			user = *model
			exists = true
		}
	}
	if input.Username != nil {
		model, err := s.repo.FindByUsername(*input.Username)
		if err == nil {
			user = *model
			exists = true
		}
	}

	if !exists {
		return false, &userModels.UserDto{}
	}
	return helper.ComparePassword(user.Password, password), user.ToResponseDto()
}
