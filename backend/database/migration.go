package database

import auth "silance/modules/auth/models"

func InitiateMigration() {
	err := DBConnection.AutoMigrate(
		&auth.User{},
	)

	if err != nil {
		panic(err)
	}
}
