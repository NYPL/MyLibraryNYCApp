import React from "react";
import { render } from "react-dom";
import App from "../components/App";
import { BrowserRouter } from "react-router-dom";



// import ReactOnRails from 'react-on-rails';

// import SearchTeacherSets from '../bundles/SearchTeacherSets/components/SearchTeacherSets';

// ReactOnRails.register({
//   SearchTeacherSets,
// });

import "../styles/application.scss"

document.addEventListener("DOMContentLoaded", () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>, 
    document.body.appendChild(document.createElement("div"))
  );
});
