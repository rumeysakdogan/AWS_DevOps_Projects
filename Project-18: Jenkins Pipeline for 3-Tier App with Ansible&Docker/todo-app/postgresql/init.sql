CREATE DATABASE rumeysatodo;

\c rumeysatodo;

CREATE TABLE todo(
    todo_id SERIAL PRIMARY KEY,
    description VARCHAR(255)
);