// Entry point for the build script in your package.json
import React, { Component, useState } from 'react';
import { createRoot } from 'react-dom/client';
import App from "./components/App";
import "./stylesheets/application.scss";

const container = document.getElementById('user_data');
const root = createRoot(container);
root.render(<App />);
