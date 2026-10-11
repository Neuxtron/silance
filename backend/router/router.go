package router

import (
	"silance/helper"
	"silance/modules/auth"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func Initialize() {
	router := gin.Default()
	if !helper.IsProd {
		router.Use(cors.New(cors.Config{
			AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
			AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Accept", "Authorization"},
			ExposeHeaders:    []string{"Content-Length"},
			AllowCredentials: true,
			MaxAge:           12 * time.Hour,
			AllowAllOrigins:  true,
		}))
	}
	api := router.Group(helper.GetEnv("API_VERSION"))

	auth.InitiateRoutes(api)

	router.Run(helper.GetEnv("APP_PORT"))
}
