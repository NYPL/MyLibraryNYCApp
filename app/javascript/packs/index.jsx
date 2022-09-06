import React, { Component, useState } from 'react';
import { render } from "react-dom";
import App from "../components/App";
import { BrowserRouter } from "react-router-dom";
import ReactOnRails from 'react-on-rails';
import Header from '../components/Header';


// This is how react_on_rails can see the Header in the browser.
ReactOnRails.register({
  Header, App
});

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById('user_data')
  const data = JSON.parse(node.getAttribute('data'))
  render(
    <BrowserRouter>
      <App userSignedIn={node}/>
    </BrowserRouter>, 
    document.body.appendChild(document.createElement("div"))
  );
});
