package middlewares

import (
	"log"
	"silance/common"
	"silance/helper"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

const UserIdKey = "user_id"
const PhoneKey = "phone"

func AuthMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		authHeaders := ctx.Request.Header.Get("Authorization")
		if authHeaders == "" {
			common.NewResponse(ctx, 401, "You are not logged in", nil)
			return
		}

		tokenStr := strings.TrimPrefix(authHeaders, "Bearer ")
		claims, claimsErr := helper.ParseJWT(tokenStr)

		if claimsErr != nil {
			if !helper.IsProd {
				log.Printf("Failed to parse jwt token: %s\n", claimsErr)
			}
			common.NewResponse(ctx, 401, "Your session is expired, please login again", nil)
			return
		}
		ctx.Set(UserIdKey, claims.UserID)
		ctx.Set(PhoneKey, claims.Phone)

		ctx.Next()
	}
}

func CurrentUser(ctx *gin.Context) (userId uuid.UUID, phone string) {
	userId = ctx.MustGet(UserIdKey).(uuid.UUID)
	phone = ctx.MustGet(PhoneKey).(string)
	return
}
