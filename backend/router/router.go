package router

import (
	"silance/helper"

	"github.com/gin-gonic/gin"
)

func Initialize() {
	router := gin.Default()
	// api := router.Group(helper.GetEnv("API_VERSION"))

	router.Run(helper.GetEnv("APP_PORT"))
}
