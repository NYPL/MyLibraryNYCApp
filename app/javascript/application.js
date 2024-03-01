// Entry point for the build script in your package.json
import React, { Component, useState } from 'react';
import App from "./components/App";
import ReactDOM from 'react-dom';
import "./stylesheets/application.scss";

ReactDOM.render(
    <App />,
  document.getElementById("user_data")
);