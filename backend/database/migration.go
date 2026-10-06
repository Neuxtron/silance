package database

func InitiateMigration() {
	err := DBConnection.AutoMigrate()

	if err != nil {
		panic(err)
	}
}
