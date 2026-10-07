package helper

import (
	"errors"

	"github.com/jackc/pgx/v5/pgconn"
)

func TranslateUniqueError(err error, constraints map[string]string) error {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == "23505" { // unique_violation
		if msg, ok := constraints[pgErr.ConstraintName]; ok {
			return errors.New(msg)
		}
	}
	return err // not a recognized unique violation, return as-is
}
