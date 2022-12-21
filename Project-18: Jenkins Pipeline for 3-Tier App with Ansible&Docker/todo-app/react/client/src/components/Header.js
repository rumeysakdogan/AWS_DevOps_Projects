import React from "react";
import rdtodo from "../assets/rdtodo.svg";
import "./style.css";

const Header = () => {
  return (
    <div>
      <div className="text-center">
        <img src={rdtodo} alt="rdtodolist" className="rdtodo" />
        <h1 className="text-center mt-5 header-text">Rumeysa Todos</h1>
      </div>
    </div>
  );
};

export default Header;
