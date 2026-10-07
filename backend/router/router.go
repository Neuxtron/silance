package router

import (
	"silance/helper"
	"silance/modules/auth"

	"github.com/gin-gonic/gin"
)

func Initialize() {
	router := gin.Default()
	api := router.Group(helper.GetEnv("API_VERSION"))

	auth.InitiateRoutes(api)

	router.Run(helper.GetEnv("APP_PORT"))
}
