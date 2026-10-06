package helper

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

var IsProd = GetEnv("APP_ENV") == "production"

func GetEnv(key string) string {
	godotenv.Load(".env")

	keyString := os.Getenv(key)
	if keyString == "" {
		log.Fatal("Env key not found: " + key)
	}

	return keyString
}
