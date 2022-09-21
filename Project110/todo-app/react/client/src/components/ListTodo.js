import React, { Fragment, useEffect, useState } from "react";
import EditTodo from "./EditTodo";
import "./style.css";
const BASE_URL = process.env.REACT_APP_BASE_URL;

const ListTodo = () => {
  const [todos, setTodos] = useState([]);

  //delete todo function

  const deleteTodo = async (id) => {
    try {
      const deleteTodo = await fetch(`${BASE_URL}todos/${id}`, {
        method: "DELETE",
      });

      console.log(deleteTodo);
      setTodos(todos.filter((todo) => todo.todo_id !== id));
    } catch (err) {
      console.error(err.message);
    }
  };

  const getTodos = async () => {
    try {
      const response = await fetch(`${BASE_URL}todos`);
      const jsonData = await response.json();

      setTodos(jsonData);
    } catch (err) {
      console.error(err.message);
    }
  };

  useEffect(() => {
    getTodos();
  }, []);

  return (
    <Fragment>
      <table className="table mt-5 text-center">
        <thead className="list-header text-white">
          <tr>
            <th>Description</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          {todos.map((todo) => (
            <tr key={todo.todo_id}>
              <td>{todo.description}</td>
              <td>
                <EditTodo todo={todo} />
              </td>
              <td>
                <button
                  className="btn btn-danger"
                  onClick={() => deleteTodo(todo.todo_id)}
                >
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </Fragment>
  );
};

export default ListTodo;
