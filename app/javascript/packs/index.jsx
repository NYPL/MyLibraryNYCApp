import React from "react";
import { render } from "react-dom";
import App from "../components/App";
import { BrowserRouter } from "react-router-dom";



document.addEventListener("DOMContentLoaded", () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>, 
    document.body.appendChild(document.createElement("div"))
  );
});
