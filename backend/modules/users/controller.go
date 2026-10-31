package users

import (
	"silance/common"
	"silance/middlewares"

	"github.com/gin-gonic/gin"
)

type Controller struct {
	service Service
}

func NewController(service Service) *Controller {
	return &Controller{service}
}

func (c *Controller) GetHomeUsers(ctx *gin.Context) {
	id, _ := middlewares.CurrentUser(ctx)
	users, err := c.service.GetHomeUsers(id)
	if err != nil {
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}
	common.NewResponse(ctx, 200, "Successfully got all users", users)
}
