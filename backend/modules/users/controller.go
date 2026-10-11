package users

import (
	"silance/common"

	"github.com/gin-gonic/gin"
)

type Controller struct {
	service Service
}

func NewController(service Service) *Controller {
	return &Controller{service}
}

func (c *Controller) GetAllUsers(ctx *gin.Context) {
	users, err := c.service.GetAll()
	if err != nil {
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}
	common.NewResponse(ctx, 200, "Successfully got all users", users)
}
