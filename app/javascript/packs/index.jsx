import React from "react";
import { render } from "react-dom";
import App from "../components/App";
import { BrowserRouter } from "react-router-dom";



import ReactOnRails from 'react-on-rails';

import ParticipatingSchools from '../components/ParticipatingSchools';


// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register(

	{
	  ParticipatingSchools,
	}
);



document.addEventListener("DOMContentLoaded", () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>, 
    document.body.appendChild(document.createElement("div"))
  );
});
