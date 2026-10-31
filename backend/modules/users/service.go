package users

import (
	"log"
	"silance/modules/users/models"

	"github.com/google/uuid"
)

type Service interface {
	GetHomeUsers(id uuid.UUID) ([]models.UserDto, error)
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo}
}

// GetHomeUsers implements [Service].
func (s *service) GetHomeUsers(id uuid.UUID) ([]models.UserDto, error) {
	users, err := s.repo.FindHomeData(id)
	if err != nil {
		log.Printf("Failed to get users: %s\n", err)
		return []models.UserDto{}, err
	}

	usersDto := []models.UserDto{}
	for _, user := range users {
		usersDto = append(usersDto, *user.ToResponseDto())
	}
	return usersDto, nil
}
