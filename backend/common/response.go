package common

import "github.com/gin-gonic/gin"

type APIResponse struct {
	Status  bool        `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

func NewResponse(ctx *gin.Context, code int, message string, data interface{}) any {
	status := code < 300
	ctx.JSON(
		code,
		APIResponse{
			Status:  status,
			Message: message,
			Data:    data,
		},
	)
	ctx.Abort()
	return nil
}

func NewInternalServerErrorResponse(ctx *gin.Context, data interface{}) any {
	ctx.JSON(
		500,
		APIResponse{
			Status:  false,
			Message: "Something went wrong, please try again",
			Data:    data,
		},
	)
	ctx.Abort()
	return nil
}
