package auth

import (
	"log"
	"silance/modules/auth/models"

	"github.com/google/uuid"
)

type Service interface {
	CreateUser(*models.UserDto) error
	UpdateUser(id uuid.UUID, input *models.UserDto) error
	FindAll() ([]models.UserDto, error)
	FindSingle(uuid.UUID) (*models.UserDto, error)
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo}
}

// CreateUser implements [Service].
func (s *service) CreateUser(input *models.UserDto) error {
	id, err := uuid.NewV7()
	if err != nil {
		log.Printf("Failed to generate UUID: %s\n", err)
		return err
	}

	user := &models.User{
		ID:          id,
		Phone:       input.Phone,
		Username:    input.Username,
		DisplayName: input.DisplayName,
	}

	if err := s.repo.CreateUser(user); err != nil {
		log.Printf("Failed to create user: %s\n", err)
		return err
	}

	*input = *user.ToResponseDto()
	return err
}

// FindAll implements [Service].
func (s *service) FindAll() ([]models.UserDto, error) {
	users, err := s.repo.FindAll()
	if err != nil {
		log.Printf("Failed to get all users: %s\n", err)
		return []models.UserDto{}, err
	}

	usersDto := []models.UserDto{}
	for _, user := range users {
		usersDto = append(usersDto, *user.ToResponseDto())
	}
	return usersDto, nil
}

// FindSingle implements [Service].
func (s *service) FindSingle(id uuid.UUID) (*models.UserDto, error) {
	user, err := s.repo.FindSingle(id)
	return user.ToResponseDto(), err
}

// UpdateUser implements [Service].
func (s *service) UpdateUser(id uuid.UUID, input *models.UserDto) error {
	user := &models.User{
		Phone:       input.Phone,
		Username:    input.Username,
		DisplayName: input.DisplayName,
	}
	err := s.repo.UpdateUser(id, user)

	*input = *user.ToResponseDto()
	return err
}
