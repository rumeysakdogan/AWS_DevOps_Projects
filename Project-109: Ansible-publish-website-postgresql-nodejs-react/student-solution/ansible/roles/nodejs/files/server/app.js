const express = require("express");
const cors = require("cors");
require("dotenv").config();

const pool = require("./db");

const app = express();

app.use(express.json()); // req.body
app.use(cors());

// ROUTES

// get all todos
app.get("/todos", async (req, res) => {
  try {
    const allTodos = await pool.query("SELECT * FROM todo");
    res.json(allTodos.rows);
  } catch (error) {
    console.error(error.message);
  }
});

// get a todo
app.get("/todos/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const todo = await pool.query("SELECT * FROM todo WHERE todo_id = $1", [
      id,
    ]);
    res.json(todo.rows);
  } catch (error) {
    console.error(error.message);
  }
});

// create a todo
app.post("/todos", async (req, res) => {
  try {
    console.log(req.body);
    const { description } = req.body;
    const newTodo = await pool.query(
      "INSERT INTO todo (description) VALUES ($1) RETURNING *",
      [description]
    );
    res.json(newTodo.rows);
  } catch (error) {
    console.error(error.message);
  }
});

// update a todo
app.put("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params; // WHERE
    const { description } = req.body; // SET
    const updateTodo = await pool.query(
      "UPDATE todo SET description = $1 WHERE todo_id = $2",
      [description, id]
    );
    res.json("Todo was updated!");
  } catch (error) {
    console.error(error.message);
  }
});

// delete a todo
app.delete("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const deleteTodo = await pool.query("DELETE FROM todo WHERE todo_id = $1", [
      id,
    ]);
    res.json("Todo was deleted successfully!");
  } catch (error) {
    console.error(error.message);
  }
});

app.listen(process.env.SERVER_PORT, () => {
  console.log(`Server running on http://localhost:${process.env.SERVER_PORT}`);
});
