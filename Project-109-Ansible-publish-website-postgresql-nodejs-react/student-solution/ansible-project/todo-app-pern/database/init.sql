CREATE DATABASE clarustodo;

\c clarustodo;

CREATE TABLE todo(
    todo_id SERIAL PRIMARY KEY,
    description VARCHAR(255)
);