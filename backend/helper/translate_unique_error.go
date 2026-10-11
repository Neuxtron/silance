package helper

import (
	"errors"

	"github.com/jackc/pgx/v5/pgconn"
)

func TranslateUniqueError(err error, constraints map[string]string) (bool, error) {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == "23505" { // unique_violation
		if msg, ok := constraints[pgErr.ConstraintName]; ok {
			return true, errors.New(msg)
		}
	}
	return false, err // not a recognized unique violation, return as-is
}
