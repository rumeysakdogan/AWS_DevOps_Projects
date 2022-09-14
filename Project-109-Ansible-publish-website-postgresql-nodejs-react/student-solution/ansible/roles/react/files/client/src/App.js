import React, { Fragment } from "react";
import InputTodo from "./components/InputTodo";
import ListTodo from "./components/ListTodo";
import Header from "./components/Header";
import "./App.css";

function App() {
  return (
    <Fragment>
      <div className="container">
        <Header />
        <InputTodo />
        <ListTodo />
      </div>
    </Fragment>
  );
}

export default App;
