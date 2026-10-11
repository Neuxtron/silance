package users

import (
	"log"
	"silance/modules/users/models"
)

type Service interface {
	GetAll() ([]models.UserDto, error)
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo}
}

// GetAll implements [Service].
func (s *service) GetAll() ([]models.UserDto, error) {
	users, err := s.repo.FindAll()
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
