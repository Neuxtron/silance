package auth

import (
	"log"
	"silance/common"
	"silance/helper"
	"silance/middlewares"
	"silance/modules/auth/models"

	"github.com/gin-gonic/gin"
)

type Controller struct {
	service Service
}

func NewController(service Service) *Controller {
	return &Controller{service}
}

func (c *Controller) Register(ctx *gin.Context) {
	var input models.RegisterDto
	if err := ctx.ShouldBindJSON(&input); err != nil {
		common.NewResponse(ctx, 400, err.Error(), nil)
		return
	}

	user, err := c.service.CreateAccount(&input)
	hasDuplicate := translateUniques(&err)
	if hasDuplicate {
		common.NewResponse(ctx, 409, err.Error(), nil)
		return
	}

	if err != nil {
		log.Printf("Failed to create user: %s\n", err)
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}

	token, err := helper.GenerateJWT(user.ID, input.Phone)
	if err != nil {
		log.Printf("Failed to generate JWT token: %s\n", err)
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}

	common.NewResponse(ctx, 201, "Successfully created user", map[string]any{
		"user":  user,
		"token": token,
	})
}

func (c *Controller) Login(ctx *gin.Context) {
	var input models.LoginDto
	if err := ctx.Bind(&input); err != nil {
		common.NewResponse(ctx, 400, "Bad request", nil)
		return
	}

	valid, user := c.service.Login(input, input.Password)
	if !valid {
		common.NewResponse(ctx, 401, "Invalid credentials", nil)
		return
	}

	token, err := helper.GenerateJWT(user.ID, user.Phone)
	if err != nil {
		common.NewResponse(ctx, 500, "Something went wrong, please login again", nil)
		return
	}

	common.NewResponse(ctx, 200, "Successfully logged in", map[string]any{
		"user":  user,
		"token": token,
	})
}

func (c *Controller) UpdateProfile(ctx *gin.Context) {

}

func (c *Controller) GetProfile(ctx *gin.Context) {
	id, _ := middlewares.CurrentUser(ctx)
	user, err := c.service.GetProfile(id)
	if err != nil {
		common.NewInternalServerErrorResponse(ctx, nil)
		return
	}

	common.NewResponse(ctx, 200, "Successfully got profile", user)
}

func translateUniques(err *error) bool {
	if err != nil {
		var isUniqueViolation bool
		isUniqueViolation, *err = helper.TranslateUniqueError(*err, map[string]string{
			"idx_users_phone":    "Phone number is already registered",
			"idx_users_username": "This username is already used",
		})
		return isUniqueViolation
	}
	return false
}
