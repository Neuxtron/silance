package helper

import (
	"errors"
	"log"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type JWTClaims struct {
	UserID uuid.UUID `json:"user_id"`
	Phone  string    `json:"phone"`
	jwt.RegisteredClaims
}

func GenerateJWT(userID uuid.UUID, phone string) (string, error) {
	jwtSecret := []byte(GetEnv("JWT_SECRET"))
	claims := JWTClaims{
		UserID: userID,
		Phone:  phone,
		RegisteredClaims: jwt.RegisteredClaims{
			IssuedAt: jwt.NewNumericDate(time.Now()),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

func ParseJWT(tokenStr string) (*JWTClaims, error) {
	jwtSecret := []byte(GetEnv("JWT_SECRET"))

	token, err := jwt.ParseWithClaims(tokenStr, &JWTClaims{}, func(t *jwt.Token) (any, error) {
		return jwtSecret, nil
	})

	if err != nil || !token.Valid {
		return nil, err
	} else if claims, ok := token.Claims.(*JWTClaims); ok {
		return claims, nil
	} else {
		log.Fatal("Unknown claims type")
		return nil, errors.New("Unknown claims type")
	}
}
