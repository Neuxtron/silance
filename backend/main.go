package main

import (
	"silance/database"
	"silance/router"
)

func main() {
	database.Initialize()
	database.InitiateMigration()
	router.Initialize()
}
