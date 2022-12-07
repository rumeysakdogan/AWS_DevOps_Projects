import React, { Fragment, useState } from "react";
import "./style.css";
const BASE_URL = process.env.REACT_APP_BASE_URL;

console.log(BASE_URL);

const InputTodo = () => {
  const [description, setDescription] = useState("");
  const [error, setError] = useState("");

  const submitForm = async (e) => {
    e.preventDefault();
    try {
      if (description) {
        setError("");
        const body = { description };
        const response = await fetch(`${BASE_URL}todos`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(body),
        });

        console.log(response);
        //   setDescription("");
        window.location = "/";
      } else {
        console.log("Enter todo!");
        setError("Enter todo!");
      }
    } catch (error) {
      console.error(error.message);
    }
  };

  return (
    <Fragment>
      <form className="d-flex mt-5" onSubmit={submitForm}>
        <input
          type="text"
          className="form-control"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
        <button className="btn btn-success">Add</button>
      </form>
      {error ? <h5 className="text-center text-danger mt-2">{error}</h5> : null}
    </Fragment>
  );
};

export default InputTodo;
