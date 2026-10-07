package auth

import (
	"silance/common"
	"silance/modules/auth/models"

	"github.com/gin-gonic/gin"
)

type Controller struct {
	service Service
}

func NewController(service Service) *Controller {
	return &Controller{service}
}

func (c *Controller) CreateUser(ctx *gin.Context) {
	var input models.UserDto
	if err := ctx.ShouldBindJSON(&input); err != nil {
		common.NewResponse(ctx, 400, err.Error(), nil)
		return
	}
	if err := c.service.CreateUser(&input); err != nil {
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}
	common.NewResponse(ctx, 201, "Successfully created user", input)
}

func (c *Controller) UpdateProfile(ctx *gin.Context) {

}

func (c *Controller) GetAllUsers(ctx *gin.Context) {
	users, err := c.service.FindAll()
	if err != nil {
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}
	common.NewResponse(ctx, 200, "Successfully got all users", users)
}

func (c *Controller) GetProfile(ctx *gin.Context) {

}
