package database

import (
	"fmt"
	"log"
	"silance/helper"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

var DBConnection *gorm.DB

func Initialize() {
	var dsn string = fmt.Sprintf("postgres://%s:%s@%s/%s?sslmode=disable",
		helper.GetEnv("DB_USERNAME"),
		helper.GetEnv("DB_PASSWORD"),
		helper.GetEnv("DB_HOST"),
		helper.GetEnv("DB_NAME"),
	)

	// Connecting database
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{},
	})

	if err != nil {
		panic(err)
	}

	log.Println("Database Connected")
	DBConnection = db
}
