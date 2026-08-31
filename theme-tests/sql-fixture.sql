CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  score REAL CHECK (score >= 0)
);

INSERT INTO users (id, name, active, score) VALUES
  (1, 'Ada', TRUE, 9.5),
  (2, 'Lin', FALSE, 7.0),
  (3, 'Kai', TRUE, 8.25);

WITH ranked AS (
  SELECT name, score, ROW_NUMBER() OVER (ORDER BY score DESC) AS position
  FROM users
  WHERE active = TRUE
)
SELECT name, score
FROM ranked
WHERE position <= 2;
