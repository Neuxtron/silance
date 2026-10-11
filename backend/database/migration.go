package database

import users "silance/modules/users/models"

func InitiateMigration() {
	err := DBConnection.AutoMigrate(
		&users.User{},
	)

	if err != nil {
		panic(err)
	}
}
